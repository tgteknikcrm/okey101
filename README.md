# Okey 101

Turkish Yüzbir Okey as an offline-first **Flutter Web** PWA. One human player
against three rule-following bots. No app store, no backend, no accounts.

**Live:** https://tgteknikcrm.github.io/okey101/

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
├── generate_icons.dart   dependency-free PWA icon generator
└── simulate.dart         bulk game simulation
```

`lib/domain/` is pure Dart: no Flutter, no `dart:ui`, no `dart:io`, no
`dart:math`, no clock, no ambient randomness. This is enforced by
`test/purity_test.dart`, not by convention.

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
| `flutter build web --release --base-href /okey101/` | Production bundle |

## Platform

Web only. There is deliberately no Android or iOS build: no Android SDK, no JDK,
no native toolchain. The default (CanvasKit) renderer is used; `--wasm` is not,
because multi-threaded wasm needs COOP/COEP headers and WasmGC support in
WebKit-based iOS browsers is unreliable.

## Deployment

Pushing to `main` runs `.github/workflows/deploy.yml`, which builds and deploys
to GitHub Pages. Repository **Settings → Pages → Source** must be
**GitHub Actions**.

> Service workers cache aggressively. If a change does not show up after a push,
> fully close and reopen the installed app.
