# Working in this repository

Okey 101 (Turkish Yüzbir Okey) as an offline-first Flutter Web PWA: one human
against three bots, no backend, no accounts, no store.

This file is the contract. It is written for whoever works here next — human or
agent — and everything in it was paid for at least once. Read the **Traps**
section before touching layout or gestures.

---

## 1. Hard rules

These are not preferences. Breaking one of them breaks the build, a test, or the
deployment.

### Language

- **All prose to the owner is Turkish.** Explanations, plans, summaries,
  questions.
- **All code is English.** Identifiers, comments, commit messages, doc comments.
- **User-facing strings live in ARB files.** Never a literal in a widget. Add
  the key to `lib/l10n/arb/app_tr.arb` *and* `app_en.arb`, then
  `flutter gen-l10n`.

### Platform

Web only, and deliberately so. There is no Android or iOS build.

- Do **not** install the Android SDK, a JDK, or any native toolchain.
- Do **not** produce an APK, AAB or IPA.
- Default (CanvasKit) renderer. `--wasm` is forbidden: multi-threaded wasm needs
  COOP/COEP headers, and WasmGC on WebKit-based iOS browsers is unreliable.

### Dependencies

Pinned and settled. Do not re-litigate them.

| Allowed | Why |
|---|---|
| `flutter_riverpod ^3.x` | **manual API only** — `NotifierProvider` / `Provider`. No codegen. |
| `riverpod_annotation ^4.x` | graph pin only, never used directly |
| `freezed ^3.x` | `abstract class` for a single constructor, `sealed class` for unions |
| `json_serializable` | with `explicit_to_json: true` in `build.yaml` |
| `shared_preferences` | the **only** persistence — maps to `localStorage` on web |
| `intl` | exact pin |
| `build_runner` | never with `--delete-conflicting-outputs` |
| `very_good_analysis`, `mocktail` | lints and test doubles |

**Banned outright:** `path_provider`, `hive`, `isar`, `sqflite`,
`riverpod_generator`, `riverpod_lint`, anything that reaches for `dart:io`.

### `lib/domain/` is pure Dart

No Flutter, no `dart:ui`, no `dart:io`, **no `dart:math`**, no clock, no ambient
randomness. Enforced by `test/purity_test.dart`, which greps for banned tokens
and asserts it found at least 15 files.

The `dart:math` ban is the one that surprises people. It exists so that
`RandomSource` — a hand-written xorshift32 — stays the only source of randomness
in the game. The test greps for the literal string, **including inside
comments**: a comment mentioning the library by name fails the build. Write
`min` out by hand rather than importing it.

`lib/features/` may use `dart:math` freely.

### Redaction

No file under `lib/domain/ai/` may contain the token `GameState`. Bots see a
`PlayerView` and nothing else. Enforced by test.

### Widgets hold no game logic

Every decision goes through `GameController` → `GameEngine`. Illegal actions
return a typed `GameError`; nothing throws.

---

## 2. Commands

The Flutter SDK is at `C:\src\flutter` and is **not on PATH**. Every shell that
runs it needs:

```bash
export PATH="/c/src/flutter/bin:/c/src/flutter/bin/cache/dart-sdk/bin:$PATH"
```

| Command | Notes |
|---|---|
| `flutter analyze` | must be clean, no exceptions |
| `flutter test` | 277 tests, ~50 s |
| `dart run build_runner build` | after touching a freezed or json model |
| `flutter gen-l10n` | after touching an ARB file |
| `bash tool/publish.sh` | analyse → test → build → push to `gh-pages` → poke Pages |
| `dart run tool/simulate.dart --games 2000 --lineup hard,medium,hard,medium` | bot strength |
| `dart run tool/pairs_probe.dart --games 120` | how often the pairs road is taken |
| `dart run tool/meld_length_probe.dart --games 150` | how long table melds get |

`tool/publish.sh` must be run from **Git Bash**, and it sets
`MSYS_NO_PATHCONV=1` itself — without that, MSYS rewrites `--base-href
/okey101/` into `C:/Program Files/Git/okey101/` and the build fails with
`Target file "n" not found`.

---

## 3. Architecture in one screen

```
main.dart → Okey101App → ForceLandscape → routes
                                            │
lib/domain/   PURE. models, rules, engine, ai. Knows nothing about Flutter.
lib/data/     LocalStore over shared_preferences. Settings, saved game,
              history, wallet.
lib/features/ UI, feature-first. Widgets lay out and report taps.
lib/app/      MaterialApp, theme, providers (the DI root).
lib/core/     shared helpers, web/stub conditional imports.
```

The engine is a pure function:

```dart
GameEngine.apply(GameState, GameAction) -> EngineOk | EngineErr
```

All randomness lives in `GameState.randomState`, advanced by `RandomSource`, so
`(seed, canonicalActions)` reproduces a match exactly. `MatchRunner.replay`
proves it in the test suite.

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the full map.

---

## 4. Layout constants

The landscape board is the shape the game is played in; `ForceLandscape`
rotates a portrait handset into it with a `RotatedBox` before anything is built.

| Constant | Value | Where |
|---|---|---|
| `sideRailWidth` | 70 | `_Board` |
| `deckColumnWidth` | 54 | `_Board` |
| `pairsPanelWidth` | 46 | `_Board` |
| `sortColumnWidth` / `sortButtonHeight` | 62 / 46 | `_Board` |
| `rackHeightShare` | 0.30 | `_Board` |
| `_GameHeader.height` | 34 | `game_screen.dart` |
| `_TopStrip.height` | 38 | `game_screen.dart` |
| `columnsPerHalf` | 13 | `board_layout.dart` |
| `pairColumns` | 2 | `board_layout.dart` |
| `MeldBoard._rows` | 5 | `meld_board.dart` |
| `MeldBoard._cellScale` | 0.9 | `meld_board.dart` |
| `kRackColumns` × `kRackRows` | 13 × 2 | `game_session.dart` |

**Why 13.** The longest legal meld is the run 1..13. A run is capped at 5 tiles
*at lay-down* (`maxRunLengthOnLayDown`), but `addToMeld` may extend a table run
past that, so a meld really can reach 13 cells. Thirteen columns guarantees no
legal meld ever has to wrap. Measured over 1,628 simulated hands: 84.6% of melds
are 3–4 tiles, 0.51% are longer than 8.

**The table is a rotation.** A discard pile belongs at the corner between the
player who threw the tile and the player entitled to take it, and okey passes to
the right:

```
        top-left: the far seat threw       top-right: the right seat threw
   left seat ●            (board)            ● right seat
     bottom-left: the left seat threw    bottom-right: YOU threw
       (the only pile you may take)      (drop a tile here to throw it)
```

---

## 5. Traps

Every one of these cost a round trip. They are ordered by how easy they are to
walk back into.

### Layout

- **`globalToLocal` on the rack is not the tile coordinate space.** The rack is
  centred inside its band whenever the height cap bites — which is every
  landscape phone — so the gesture callbacks and `globalToLocal` disagree by
  `_insetX`. Forgetting it put a tile released on the fourth slot down on the
  eighth. Rack tests must set a `maxHeight` low enough to actually bite (at 390
  wide the rack is 93 tall on its own, so anything above that leaves the inset
  at zero and the bug hidden).
- **`CustomPainter` does not clip.** `_GridPainter` used to draw
  `columnsPerHalf` columns unconditionally, so the two-column pairs panel spilled
  empty cells across the seat rail beside it. Pass the column count in.
- **`CrossAxisAlignment.stretch` in an unbounded Column forces infinite
  height.** The rack sizes itself from its own constraints, so the row beside it
  needs fixed heights, not `Expanded`.
- **A mandatory tap target must never be inside a scroll view.** The deck sat in
  one with two other slots; on any landscape phone shorter than 390 logical
  pixels the column overflowed and the deck was clipped — with no scrollbar to
  say so. Tapping it did nothing.
- **`MaterialTapTargetSize.padded` silently floors every button at 48.**
- **Exotic Unicode is a tofu box on some phones.** `✻` (U+273B) and `★`
  (U+2605) are in neither Roboto nor every fallback stack. Both marks are drawn
  on the canvas now. Do not type a symbol into a tile.

### Gestures

- **Never refuse a tap in silence.** A control that does nothing when tapped is
  indistinguishable from a broken one. It is the single most reported "bug" in
  this project's history. Let the action reach the controller and be refused out
  loud with a `GameError`.
- **The pan recogniser lags a fast flick.** Take the release point from the raw
  pointer stream (`Listener.onPointerMove` → `event.position`), not from
  `DragUpdateDetails` or `DragEndDetails`. The gap was four rack slots.
- **One `PanGestureRecognizer` covers the whole rack**, and it only reports
  `onPanEnd` when the *last* finger lifts. A thumb resting on the rack — the
  normal grip in landscape — strands the dragged tile. The rack owns the pointer
  stream through a `Listener` for exactly this reason.
- **A `GestureDetector` drops its recogniser when every pan callback is null**,
  and disposing one mid-drag clears its tracked pointers without calling either
  terminal callback. Keep `onPanEnd`/`onPanCancel` non-null and test the enabled
  flag inside.
- **A pan that wins the arena but barely moves must be treated as a tap.** The
  tap recogniser has already lost by then, so the touch is otherwise swallowed
  whole.
- **Arranging the rack is not a move.** No layout or selection method on the
  controller looks at the turn, and the widget must not either. Locking the rack
  to the player's turn takes away the only thing there is to do while three bots
  play.

### Engine and bots

- **The seat that deals starts with 22 tiles in `awaitingDiscard`.** The deck is
  legitimately dead on that turn — two or three hands of every match. Say so.
- **A bot brain that throws used to take the table with it.** The exception
  escaped into an unawaited future and the turn stayed on that bot for ever,
  surviving a reload because the save ran the same brain into the same throw.
  The decision is wrapped; the fallback is the dullest legal move.
- **`_disposed` must be reset in `build()`.** `NotifierProvider` is not
  auto-dispose and Riverpod keeps the instance across rebuilds.
- **Bots are stateless.** `decide(view, rng)` gets a view and nothing else, so
  any plan spanning turns has to be re-derivable from the rack. `BotUtils.pairsRoad`
  is the worked example.

### Testing and verification

- **Benchmarks must be measured in Chrome, not the Dart VM.** The VM is several
  times faster than compiled JavaScript. State the environment with the number.
- **`flutter test --platform chrome` hangs** in this environment. Compile with
  `dart compile js` and run headless Chrome with `--dump-dom` instead.
- **A widget test that leaves a timer pending fails.** Putting the table on a
  bot's turn starts the think timer. Either pass `fastMode: true` (delay 0, no
  timer), pump unsettled and drain at the end, or move the assertion to a plain
  `test()`.
- **Verify a fix by making the test fail against the unfixed code first.** Every
  regression test in this repo was checked that way, and two of them did not
  bite on the first attempt — the harness was wrong, not the code.
- **Verify UI in a real browser with real touch events.** Mouse events on a
  landscape viewport never exercise the `RotatedBox` path a portrait handset
  goes through. The CDP drivers in the scratchpad do both.

---

## 6. Deployment

Pages serves the `gh-pages` branch, which holds build output only.
`bash tool/publish.sh` does everything.

This is a **deviation from the intended setup**, which is Pages → Source →
GitHub Actions. It is not installed because GitHub rejects any write under
`.github/workflows/` from a token without the `workflow` OAuth scope. The
one-time fix is in the README.

The menu carries a build stamp (`--dart-define=BUILD_ID=<sha>`, set by
`publish.sh`) so "I still see the old bug" and "the fix did not work" can be
told apart.

---

## 7. Working style the owner expects

- Do not open with questions. Take a sensible default, state the assumption, and
  carry on.
- Do not pause between phases.
- Report **measured** numbers. Never claim something is tested, working or
  verified when it is not.
- Confirm cancellations explicitly. Never silently deviate from an approved
  decision.
- The project must compile after every phase.
