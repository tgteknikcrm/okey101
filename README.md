# Okey 101

Turkish Yüzbir Okey as an offline-first **Flutter Web** PWA. One human player
against three rule-following bots. No app store, no backend, no accounts.

**Live:** https://tgteknikcrm.github.io/okey101/

## Documentation

| File | For |
|---|---|
| [`CLAUDE.md`](CLAUDE.md) | The contract: hard rules, commands, layout constants, and the traps that cost a round trip each |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Layer map, engine, solver, bots, board geometry, testing |
| [`docs/OTURUM.md`](docs/OTURUM.md) | Session log in Turkish: what was asked, what was built, **what was got wrong and how** |

Read `CLAUDE.md` before touching layout or gestures.

## Running locally

```bash
flutter pub get
dart run build_runner build
flutter run -d chrome
```

## Project layout

```
lib/
├── app/        MaterialApp, theme, DI root
├── core/       shared utilities
├── domain/     PURE DART - models, rules, engine, ai
├── data/       repositories, persistence (shared_preferences -> localStorage)
├── features/   UI, feature-first
└── l10n/       ARB files (tr default, en)
tool/
├── generate_icons.dart      dependency-free PWA icon generator
├── simulate.dart            bulk game simulation
├── pairs_probe.dart         how often bots take the pairs road
├── meld_length_probe.dart   how long table melds get
├── bench_web.dart           solver timing, compiled to JS
└── publish.sh               analyse, test, build, push to gh-pages
```

`lib/domain/` is pure Dart: no Flutter, no `dart:ui`, no `dart:io`, no maths
library, no clock, no ambient randomness. This is enforced by
`test/purity_test.dart`, not by convention. The test greps for banned tokens
**including inside comments**, so naming the maths library in a doc comment
fails the build.

`GameEngine.apply(GameState, GameAction)` is a pure function. All randomness
flows through an injected xorshift32 `RandomSource`, so every game is
reproducible from `(seed, canonicalActions)`.

## Commands

| Command | What it does |
|---|---|
| `flutter analyze` | Static analysis, must be clean |
| `flutter test` | Unit + widget tests |
| `flutter test --coverage` | Coverage into `coverage/lcov.info` |
| `dart run tool/generate_icons.dart` | Regenerate PWA icons |
| `dart run tool/simulate.dart --games 10000` | Bulk simulation |
| `dart run tool/pairs_probe.dart --games 120` | Pairs-road frequency |
| `dart run tool/meld_length_probe.dart --games 150` | Meld length distribution |
| `flutter build web --release --base-href /okey101/` | Production bundle |

## Platform

Web only. There is deliberately no Android or iOS build: no Android SDK, no JDK,
no native toolchain. The default (CanvasKit) renderer is used; `--wasm` is not,
because multi-threaded wasm needs COOP/COEP headers and WasmGC support in
WebKit-based iOS browsers is unreliable.

## Deployment

The site is live at **https://tgteknikcrm.github.io/okey101/**.

**Current setup:** Pages serves the `gh-pages` branch, which holds build output
only. To publish a change:

```bash
bash tool/publish.sh
```

That analyses, tests, builds with the right base href and a build stamp,
force-pushes the output to `gh-pages`, and asks Pages to rebuild. Run it from
**Git Bash**: it sets `MSYS_NO_PATHCONV=1` itself, without which MSYS rewrites
`--base-href /okey101/` into a Windows path and the build fails.

The build stamp shows on the menu, under the debug link. It is the short SHA the
bundle was built from, so "I still see the old bug" and "the fix did not work"
can be told apart.

### Switching to the Actions pipeline

The intended setup is Pages → *Source* → **GitHub Actions**, with
[`deploy/github-pages-workflow.yml`](deploy/github-pages-workflow.yml) doing the
build on every push to `main`. It is not installed yet because GitHub rejects
any write under `.github/workflows/` from a token without the `workflow` OAuth
scope, and the token available during development only had `gist, read:org,
repo`. Install it once, either way:

**From a terminal**

```bash
gh auth refresh -h github.com -s workflow      # one browser approval
mkdir -p .github/workflows
cp deploy/github-pages-workflow.yml .github/workflows/deploy.yml
git add .github/workflows/deploy.yml
git commit -m "Add GitHub Pages deploy workflow"
git push
```

**Or from the browser**

Repo → *Add file* → *Create new file* → name it
`.github/workflows/deploy.yml` → paste the contents of
`deploy/github-pages-workflow.yml` → *Commit*.

Then set **Settings → Pages → Source** to **GitHub Actions**. After that every
push to `main` deploys on its own and `tool/publish.sh` is no longer needed.

> Service workers cache aggressively. If a change does not show up after a
> deploy, fully close and reopen the installed app.

## Benchmarking

The Dart VM is several times faster than compiled JavaScript, so a solver
number from `flutter test` is not the number that matters. Two ways to get a
real browser figure:

```bash
# headless Chrome, no Flutter involved
dart compile js -O2 -o bench.js tool/bench_web.dart
# then open a page that loads bench.js, or use --dump-dom

# or, on the actual phone: menu → Hata Ayıklama → "MeldSolver benchmark"
```
