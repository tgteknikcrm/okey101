import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Asks for fullscreen and then locks the orientation to landscape.
///
/// `screen.orientation.lock()` rejects outside fullscreen on Android Chrome, so
/// the two go together. On iOS neither call exists in a usable form and this
/// returns having done nothing - which is why the app also rotates in software.
///
/// Must be called from a user gesture or the fullscreen request is refused.
Future<void> requestLandscape() async {
  await _requestFullscreen();
  await _lockLandscape();
}

Future<void> releaseOrientation() async {
  try {
    final screen = globalContext.getProperty<JSObject?>('screen'.toJS);
    final orientation = screen?.getProperty<JSObject?>('orientation'.toJS);
    if (orientation == null || !orientation.has('unlock')) return;
    orientation.callMethod<JSAny?>('unlock'.toJS);
  } on Object {
    // Nothing was locked.
  }
}

Future<void> _requestFullscreen() async {
  try {
    final document = globalContext.getProperty<JSObject?>('document'.toJS);
    if (document == null) return;
    // Already fullscreen: asking again throws.
    final current = document.getProperty<JSAny?>('fullscreenElement'.toJS);
    if (current != null) return;

    final element =
        document.getProperty<JSObject?>('documentElement'.toJS);
    if (element == null || !element.has('requestFullscreen')) return;
    final promise =
        element.callMethod<JSPromise<JSAny?>>('requestFullscreen'.toJS);
    await promise.toDart;
  } on Object {
    // Refused, unsupported, or not called from a gesture. Not fatal.
  }
}

Future<void> _lockLandscape() async {
  try {
    final screen = globalContext.getProperty<JSObject?>('screen'.toJS);
    if (screen == null || !screen.has('orientation')) return;
    final orientation = screen.getProperty<JSObject?>('orientation'.toJS);
    if (orientation == null || !orientation.has('lock')) return;
    final promise = orientation.callMethod<JSPromise<JSAny?>>(
      'lock'.toJS,
      'landscape'.toJS,
    );
    await promise.toDart;
  } on Object {
    // No lock available. The software rotation covers this case.
  }
}
