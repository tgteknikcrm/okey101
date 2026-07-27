import 'package:okey101/core/wake_lock_stub.dart'
    if (dart.library.js_interop) 'package:okey101/core/wake_lock_web.dart'
    as impl;

/// Keeps the screen from sleeping during a long hand.
///
/// Uses the Screen Wake Lock API where it exists and degrades silently where it
/// does not - which is most of WebKit, so silence is the normal case rather
/// than the exception. The conditional import keeps `dart:js_interop` out of
/// the VM build, so tests still run.
abstract final class WakeLock {
  static Future<void> enable() => impl.requestWakeLock();

  static Future<void> disable() => impl.releaseWakeLock();
}
