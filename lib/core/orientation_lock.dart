import 'package:okey101/core/orientation_lock_stub.dart'
    if (dart.library.js_interop) 'package:okey101/core/orientation_lock_web.dart'
    as impl;

/// Asks the browser to hold the game in landscape.
///
/// What this can actually achieve, per platform:
///  * Android, installed PWA - the manifest's `orientation: landscape` does it
///    and this is not needed.
///  * Android, browser tab - `screen.orientation.lock()` works, but only while
///    the page is fullscreen, so [requestLandscape] asks for fullscreen first.
///    It must be called from a user gesture.
///  * iOS, anywhere - there is no orientation lock at all. Both calls here are
///    no-ops, and the software rotation in `ForceLandscape` is what delivers a
///    landscape board.
///  * Desktop - locking is meaningless and simply fails.
///
/// Every failure is swallowed: none of this is load bearing.
abstract final class OrientationLock {
  /// Call from a user gesture, e.g. the tap that starts a game.
  static Future<void> requestLandscape() => impl.requestLandscape();

  static Future<void> release() => impl.releaseOrientation();
}
