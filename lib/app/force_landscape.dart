import 'package:flutter/widgets.dart';

/// Presents everything below it in landscape, whatever the device says.
///
/// The web platform cannot hard-lock orientation: the manifest's
/// `orientation: landscape` only binds an installed PWA, `screen.orientation
/// .lock()` needs fullscreen and does not exist on iOS at all, and a
/// rotation-locked phone reports portrait no matter what. So when the viewport
/// really is portrait, the whole subtree is rotated a quarter turn instead.
///
/// [RotatedBox] is used rather than [Transform.rotate] on purpose: it rotates
/// *before* layout, so the child is laid out with swapped constraints and hit
/// testing goes through the same transform. Drag gestures on the rack keep
/// working without any coordinate maths of our own.
class ForceLandscape extends StatelessWidget {
  const ForceLandscape({
    required this.enabled,
    required this.child,
    super.key,
  });

  final bool enabled;
  final Widget child;

  /// A handset is bounded on BOTH axes.
  ///
  /// The widest phone in circulation is 430 logical pixels across in portrait,
  /// while the smallest tablet is 744. 500 therefore separates phones from both
  /// tablets and the narrow desktop windows (600x900, 700x1400) that should
  /// keep the portrait layout rather than be flipped on their side.
  static const double maxHandsetShortestSide = 500;

  /// 1000 admits every phone (640, 844, 852, 896, 932) and rejects a very tall
  /// narrow window, such as a devtools panel docked to the side.
  static const double maxHandsetLongestSide = 1000;

  /// Whether a viewport of [size] would be rotated by this widget.
  static bool wouldRotate(Size size) =>
      size.width < size.height &&
      size.shortestSide <= maxHandsetShortestSide &&
      size.longestSide <= maxHandsetLongestSide;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final media = MediaQuery.of(context);
    final size = media.size;
    if (!wouldRotate(size)) return child;

    // The child believes it is landscape, so it must be told a landscape size
    // and the insets it will actually see once rotated.
    final rotated = media.copyWith(
      size: Size(size.height, size.width),
      padding: _rotate(media.padding),
      viewPadding: _rotate(media.viewPadding),
      viewInsets: _rotate(media.viewInsets),
      systemGestureInsets: _rotate(media.systemGestureInsets),
    );

    return MediaQuery(
      data: rotated,
      child: RotatedBox(quarterTurns: 1, child: child),
    );
  }

  /// Maps physical insets into the rotated child's frame.
  ///
  /// A quarter turn clockwise sends the child's top-left corner to the physical
  /// top-right, so each child edge picks up the inset of the physical edge one
  /// step anticlockwise from it:
  /// `child.left = physical.top`, `child.top = physical.right`,
  /// `child.right = physical.bottom`, `child.bottom = physical.left`.
  /// The notch therefore ends up padding the child's left edge, which is where
  /// it visually is once the phone is turned.
  static EdgeInsets _rotate(EdgeInsets insets) => EdgeInsets.fromLTRB(
        insets.top,
        insets.right,
        insets.bottom,
        insets.left,
      );
}
