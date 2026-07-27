import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// The active sentinel, so the lock can be released and re-taken.
JSObject? _sentinel;
bool _listening = false;

/// Asks the browser to keep the screen on.
///
/// Every step is guarded: `navigator.wakeLock` is missing entirely in WebKit,
/// and even where it exists the request is rejected when the page is not
/// visible. Failure here is normal and must never surface to the player.
Future<void> requestWakeLock() async {
  try {
    final navigator = globalContext.getProperty<JSObject?>('navigator'.toJS);
    if (navigator == null || !navigator.has('wakeLock')) return;
    final api = navigator.getProperty<JSObject?>('wakeLock'.toJS);
    if (api == null) return;

    final promise = api.callMethod<JSPromise<JSAny?>>(
      'request'.toJS,
      'screen'.toJS,
    );
    final result = await promise.toDart;
    _sentinel = result as JSObject?;
    _installVisibilityListener();
  } on Object {
    // No wake lock available. The game plays fine without one.
  }
}

Future<void> releaseWakeLock() async {
  try {
    final sentinel = _sentinel;
    _sentinel = null;
    if (sentinel == null) return;
    await sentinel.callMethod<JSPromise<JSAny?>>('release'.toJS).toDart;
  } on Object {
    // Already gone.
  }
}

/// A wake lock is dropped whenever the tab is hidden, so it has to be taken
/// again when the player comes back - otherwise it only works until the first
/// app switch.
void _installVisibilityListener() {
  if (_listening) return;
  _listening = true;
  try {
    final document = globalContext.getProperty<JSObject?>('document'.toJS);
    if (document == null) return;
    document.callMethod<JSAny?>(
      'addEventListener'.toJS,
      'visibilitychange'.toJS,
      (JSAny? _) {
        final state = document.getProperty<JSString?>('visibilityState'.toJS);
        if (state?.toDart == 'visible' && _sentinel == null) {
          unawaited(requestWakeLock());
        }
      }.toJS,
    );
  } on Object {
    _listening = false;
  }
}
