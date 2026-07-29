# Architecture

A map of the codebase, layer by layer, with the reasoning that is not obvious
from the source. Written for someone about to change something.

For the rules of the road — bans, commands, traps — see
[`CLAUDE.md`](../CLAUDE.md).

---

## 1. Layers

```
lib/
├── main.dart      boots the ProviderScope
├── app/           MaterialApp, routes, theme, ForceLandscape, providers
├── core/          helpers with a web/stub split (wake lock, orientation)
├── data/          LocalStore over shared_preferences, plus its models
├── domain/        PURE DART: models, rules, engine, ai
├── features/      UI, feature-first: menu, game, settings, history, rules, debug
└── l10n/          ARB files, tr default, en second
```

The dependency arrow only ever points inward: `features` → `domain`, never the
other way. `domain` imports nothing from Flutter.

---

## 2. The engine

```dart
sealed class EngineResult {}
class EngineOk  extends EngineResult { final GameState state; }
class EngineErr extends EngineResult { final GameError error; }

EngineResult GameEngine.apply(GameState state, GameAction action)
```

One pure function. No clock, no I/O, no randomness of its own — the RNG state
travels inside `GameState.randomState` and every draw advances it through
`RandomSource`, a hand-written xorshift32.

Two properties fall out of that, and both are tested:

- **Reproducibility.** `(seed, canonicalActions)` replays to a byte-identical
  final state. `MatchRunner.replay` asserts it over 40 seeds.
- **Auditability.** `StateInvariants.violation(state)` checks the 106-tile
  conservation law after every action in the simulation suite.

### Actions

`GameAction` is a freezed union: `drawFromPile`, `drawFromDiscard`, `discard`,
`open`, `layPairs`, `layMeld`, `addToMeld`, `replaceJoker`, `startNextHand`.

Illegal actions come back as `EngineErr(GameError.…)`. Nothing throws. The UI
turns the error into a sentence through `lib/core/error_messages.dart`, which is
a total switch over the union — add a variant and the compiler finds every place
that has to say something about it.

### Redaction

Bots never see `GameState`. `PlayerViewFactory.forSeat` builds a `PlayerView`
holding that seat's hand, the table, the discard piles, counts, and nothing
else. A test asserts that no file under `lib/domain/ai/` contains the token
`GameState`, so the redaction cannot be quietly undone.

---

## 3. The solver

`MeldSolver` partitions a multiset of tiles into melds. The search takes the
lowest remaining tile and either drops it into deadwood or tries every meld that
could contain it. Because tiles are indexed colour-major, "lowest remaining" is
always the first tile of its colour, so any run containing it must start at it —
which prunes hard. Results are memoised on a canonical count signature.

Three objectives, and the difference between them matters:

| Objective | Question it answers |
|---|---|
| `maximizePoints` | can I open with 101? |
| `minimizeDeadwood` | what is my rack worth if someone goes out? |
| `maximizeMeldedTiles` | **can I go out?** |

Only the third answers "can I finish" exactly: a hand can go out when it melds
all but one of its tiles, and no value-based objective decides that reliably —
leaving two cheap tiles out can score better than leaving one expensive one.

`bestPairs` is separate and cheap: pair by identity, then spend wilds on the
highest leftover singles. A rule set with `maxJokersPerMeld: 0` used to crash it
with a `RangeError`; the budget is now clamped properly.

---

## 4. The bots

`BotBrain.decide(PlayerView view, RandomSource rng) -> GameAction`. Stateless by
design: no memory between turns, so any plan spanning turns has to be
re-derivable from the rack.

| Brain | Character |
|---|---|
| `RandomBot` | legality fuzzer, used by the 500-game suite |
| `EasyBot` | greedy, never runs the deadwood solver, 15% deliberate mistakes |
| `MediumBot` | uses the solver properly, watches the seat on its right |
| `HardBot` | tracks seen tiles, models opponents, prices draws, gets more defensive as the pile empties |

Shared machinery lives in `BotUtils`, `DiscardStrategy`, `HandEvaluator`,
`SeenTiles` and `OpponentModel`.

### The pairs road

The worked example of a stateless plan. A hand holds about two pairs by chance
and needs five to open, so five are never dealt — the only way there is to
commit early and collect. `BotUtils.pairsRoad(view, bestPoints:)` re-derives the
commitment from pair count every turn, because pair count only grows while the
bot plays that way.

A committed hand draws for twins, throws whatever can never become one
(`DiscardStrategy` with `pairsFocus`), and lays as soon as it can.
`pairsToLayAfterOpening` then lays each new pair as it arrives — every bot used
to demand the whole jump from five to eleven in one move, which happened zero
times in 38,000 simulated hands.

Measured, hard ×4 over 1,319 hands: 880 pairs lay-downs where there had been
none, 1,331 after the incremental fix. Strength unchanged — 400 matches against
the same bot with the road disabled finished 198–202 — and the difficulty
ordering holds: hard 237, medium 163 over 400.

---

## 5. State and persistence

```
GameState        the engine's truth: seats, hands, table, piles, phase, rng
GameSession      GameState + everything that is only the local player's:
                 rackSlots, selection, pendingMelds, turnStart snapshots,
                 humanSeat, botThinking, lastError
```

`rackSlots` is a `List<int?>` of 26 entries. **The engine never learns about
slots** — it keeps a hand in canonical id order and the rack arrangement is
purely local. That is why none of the controller's layout or selection methods
check whose turn it is, and why the rack must stay live while the bots play.

`GameController` is a `Notifier<GameSession?>`. It owns:

- `_applyHuman` — one funnel for every human action, so a refusal is raised
  once and surfaced once
- `_runBots` / `_botLoop` — the think loop, wrapped so `botThinking` is cleared
  on **every** exit path and a throwing brain cannot strand the table
- the local-only helpers: sorting, selection, rack slots

`LocalStore` is the only persistence. `shared_preferences` maps to
`window.localStorage` on the web — roughly 5 MB, plenty for settings, history,
one saved game and a wallet. Everything is a JSON string under a namespaced key,
except the wallet, which is two plain integers because there is nothing to
version.

---

## 6. The board

### Landscape shape

```
┌──────────────────────────────────────────────────────────┐
│ ← ⚙                                     🪙 5.000 +  💎 10 │  header 34
├──────────────────────────────────────────────────────────┤
│                      ● seat opposite                     │  strip 38
│ ▫ pile        ┌────────────────────┐ deck   pairs   ▫ pile│
│ ● left seat   │   13 × 13 grid     │  54     46    ● right│
│ ▫ pile (take) │   5 rows           │ + ind.         ▫ mine│
├──────────────────────────────────────────────────────────┤
│      Geri Al  Masaya koy  Aç  Çiftleri koy  Iskarta      │  actions
├──────────────────────────────────────────────────────────┤
│ ┌────────────────── rack, 13 × 2 ──────────────┐  ┌─────┐│
│ │                                              │  │Seri ││
│ │                                              │  │Per  ││  0.30 of height
│ └──────────────────────────────────────────────┘  └─────┘│
└──────────────────────────────────────────────────────────┘
```

`ForceLandscape` rotates a portrait handset into this with a `RotatedBox`
*before* layout, so hit testing goes through the same transform. Bounds:
`maxHandsetShortestSide = 500`, `maxHandsetLongestSide = 1000` — both axes, so a
desktop window is never rotated.

### The grid

`BoardLayout.place(melds, halves:)` is a pure first-fit: scan rows top to
bottom, halves left to right, drop each meld into the first row that takes it,
leave one cell of gap between neighbours. Same table, same picture, every time.

Thirteen columns per half is not arbitrary — see CLAUDE.md §4.

`MeldBoard` sizes a cell from **both** axes: a tenth off what the width alone
would allow, and never taller than a fifth of the available height, so five rows
always fit without the last being clipped. Below `_minCell` it stops shrinking
and scrolls sideways instead of silently dropping columns.

Pairs live on their own two-column strip. A pairs player lays five to eleven of
them; mixed into the main grid they would swamp it.

### The discard piles

One at each corner, at the meeting point of the player who threw the tile and
the player entitled to take it. Because okey passes to the right, tiles travel
**up** the right-hand edge and back **down** the left. Every profile therefore
sits in the middle of its edge with a pile above and a pile below.

The bottom-right pile is the player's own; a tile dragged off the rack and
dropped on it is thrown. The rack reports the release position and the *board*
decides whether it landed there, so a throw that misses cannot also scramble the
rack.

### The rack

Two rows of thirteen, absolutely positioned so a drag can move one tile without
the layout reflowing underneath it.

While a finger is down, **only the carried tile moves**. On release,
`RackLayout.move` shoves the neighbours towards the nearest gap **in the target
row** and no further; if that row is full end to end the two tiles trade places.
At most a handful of tiles ever move. The obvious implementation — rotate
everything between source and target — moved seventeen tiles when one was
dropped, because a dealt hand fills the top row exactly.

---

## 7. Testing

277 tests, roughly 50 seconds.

| Group | What it holds |
|---|---|
| `test/domain/` | rules, solver, engine, scoring, dealer, views, bots |
| `test/domain/simulation_test.dart` | 500 seeded games, replay determinism, legality across a mixed table, and that the pairs road is taken at all |
| `test/widget/` | board layout, rack layout and gestures, the game screen, `ForceLandscape` |
| `test/purity_test.dart` | `lib/domain/` is pure, and the AI cannot see `GameState` |
| `test/benchmark/` | solver timing (Dart VM — see the caveat in CLAUDE.md) |

Diagnostics that are deliberately **not** in the suite, because they are slow
and answer questions rather than guard behaviour:

- `tool/simulate.dart` — bulk matches, win rates, hand outcomes
- `tool/pairs_probe.dart` — how often the pairs road is taken (the main
  simulation only reports how hands *finish*, so a pairs hand that runs the deck
  out shows up as "exhausted" and the road looks unused)
- `tool/meld_length_probe.dart` — how long table melds get
- `tool/bench_web.dart` — solver timing compiled to JS
