/// Non-web build: there is no browser to ask, and `dart:js_interop` does not
/// exist here, so both calls are no-ops.
Future<void> requestLandscape() async {}

Future<void> releaseOrientation() async {}
