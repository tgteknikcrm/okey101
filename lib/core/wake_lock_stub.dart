/// Non-web build: there is no screen to keep awake here, and `dart:js_interop`
/// does not exist, so both calls are no-ops.
Future<void> requestWakeLock() async {}

Future<void> releaseWakeLock() async {}
