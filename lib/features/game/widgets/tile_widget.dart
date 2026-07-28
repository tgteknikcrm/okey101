import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/domain/models/tile.dart';

/// How a tile should be drawn.
enum TileFaceKind {
  /// An ordinary numbered tile.
  normal,

  /// A numbered tile that happens to be the okey, so it is wild.
  okey,

  /// One of the two false jokers. Not wild; it counts as the indicator tile.
  falseJoker,

  /// Face down, for opponents' racks and the draw pile.
  back,
}

/// Paints one okey tile.
///
/// Everything is drawn rather than imaged so the tile stays crisp at any size
/// and the whole set costs nothing to download.
class TilePainter extends CustomPainter {
  const TilePainter({
    required this.kind,
    required this.color,
    required this.number,
    required this.colorblindGlyph,
    required this.selected,
    required this.highlighted,
    required this.dimmed,
  });

  final TileFaceKind kind;
  final TileColor? color;
  final int? number;

  /// Non-null when colourblind mode is on; drawn in the top-left corner.
  final String? colorblindGlyph;
  final bool selected;
  final bool highlighted;
  final bool dimmed;

  static Color paletteFor(TileColor color) => switch (color) {
        TileColor.red => OkeyPalette.tileRed,
        TileColor.yellow => OkeyPalette.tileYellow,
        TileColor.black => OkeyPalette.tileBlack,
        TileColor.blue => OkeyPalette.tileBlue,
      };

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 0.16;
    final body = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    if (kind == TileFaceKind.back) {
      _paintBack(canvas, size, body);
      return;
    }

    canvas
      // Drop shadow.
      ..drawRRect(
        body.shift(Offset(0, size.height * 0.035)),
        Paint()
          ..color = const Color(0x66000000)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.06),
      )
      // Ivory face with a top-to-bottom gradient.
      ..drawRRect(
        body,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [OkeyPalette.ivory, OkeyPalette.ivoryShade],
          ).createShader(Offset.zero & size),
      )
      // Bevel: a light inner edge along the top, a dark one along the bottom.
      ..save()
      ..clipRRect(body)
      ..drawRRect(
        body.deflate(size.width * 0.045),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.05
          ..color = const Color(0x55FFFFFF),
      )
      ..drawLine(
        Offset(size.width * 0.12, size.height * 0.96),
        Offset(size.width * 0.88, size.height * 0.96),
        Paint()
          ..strokeWidth = size.width * 0.05
          ..color = const Color(0x22000000),
      )
      ..restore();

    switch (kind) {
      case TileFaceKind.falseJoker:
        _paintFalseJoker(canvas, size);
      case TileFaceKind.okey:
        _paintNumber(canvas, size);
        _paintOkeyMark(canvas, size);
      case TileFaceKind.normal:
        _paintNumber(canvas, size);
      case TileFaceKind.back:
        break;
    }

    if (colorblindGlyph != null && kind != TileFaceKind.falseJoker) {
      _paintGlyph(canvas, size);
    }

    if (dimmed) {
      canvas.drawRRect(body, Paint()..color = const Color(0x66101010));
    }
    if (highlighted) {
      canvas.drawRRect(
        body.deflate(size.width * 0.03),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.08
          ..color = OkeyPalette.success,
      );
    }
    if (selected) {
      canvas.drawRRect(
        body.deflate(size.width * 0.03),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.09
          ..color = OkeyPalette.brass,
      );
    }
  }

  void _paintBack(Canvas canvas, Size size, RRect body) {
    canvas
      // Shadow, felt-coloured face, and the inset frame every tile back has.
      ..drawRRect(
        body.shift(Offset(0, size.height * 0.03)),
        Paint()
          ..color = const Color(0x55000000)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, size.width * 0.05),
      )
      ..drawRRect(
        body,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [OkeyPalette.rackLight, OkeyPalette.rack],
          ).createShader(Offset.zero & size),
      )
      ..drawRRect(
        body.deflate(size.width * 0.14),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.05
          ..color = const Color(0x33FBF5E6),
      );
  }

  void _paintNumber(Canvas canvas, Size size) {
    // Safe: only a false joker has no colour or number, and it is painted by
    // _paintFalseJoker instead.
    final ink = paletteFor(color!);
    final painter = TextPainter(
      text: TextSpan(
        text: '$number',
        style: TextStyle(
          color: ink,
          fontSize: size.height * 0.52,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(
        (size.width - painter.width) / 2,
        size.height * 0.40 - painter.height / 2,
      ),
    );

    // The felt dot every real okey tile carries under the numeral.
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.85),
      size.width * 0.075,
      Paint()..color = ink.withValues(alpha: 0.75),
    );
  }

    /// The little brass star in the corner of the tile standing in as the okey.
  ///
  /// Drawn, not typed, for the same reason as the joker: U+2605 is missing
  /// from Roboto and from some phones' fallbacks, and a tofu box in the corner
  /// of a tile reads as damage.
  void _paintOkeyMark(Canvas canvas, Size size) {
    final radius = size.height * 0.075;
    final centre = Offset(
      size.width - radius - size.width * 0.10,
      radius + size.height * 0.05,
    );

    // Ten vertices: the star's outer points and the inner ones between them,
    // starting at the top.
    final path = Path();
    for (var point = 0; point < 10; point++) {
      final r = point.isEven ? radius : radius * 0.42;
      final angle = -math.pi / 2 + point * math.pi / 5;
      final vertex = centre + Offset(math.cos(angle) * r, math.sin(angle) * r);
      if (point == 0) {
        path.moveTo(vertex.dx, vertex.dy);
      } else {
        path.lineTo(vertex.dx, vertex.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = OkeyPalette.brass);
  }

    /// The false joker's mark, drawn rather than typed.
  ///
  /// It used to be the character U+273B. Roboto does not carry it, and neither
  /// does every phone's fallback stack, so on those the sahte okey came out as
  /// an empty tofu box - and a tile you cannot identify is worse than no tile
  /// at all. Six spokes from the centre need no font.
  void _paintFalseJoker(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height / 2);
    final radius = size.height * 0.22;
    final stroke = Paint()
      ..color = OkeyPalette.tileBlack
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round;

    for (var spoke = 0; spoke < 3; spoke++) {
      final angle = math.pi * spoke / 3;
      final arm = Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      canvas.drawLine(centre - arm, centre + arm, stroke);
    }
  }

  void _paintGlyph(Canvas canvas, Size size) {
    TextPainter(
      text: TextSpan(
        text: colorblindGlyph,
        style: TextStyle(
          color: paletteFor(color!).withValues(alpha: 0.85),
          fontSize: size.height * 0.20,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(size.width * 0.08, size.height * 0.04));
  }

  @override
  bool shouldRepaint(TilePainter old) =>
      old.kind != kind ||
      old.color != color ||
      old.number != number ||
      old.colorblindGlyph != colorblindGlyph ||
      old.selected != selected ||
      old.highlighted != highlighted ||
      old.dimmed != dimmed;
}

/// A single tile. Pure presentation: it knows nothing about the rules.
class TileWidget extends StatelessWidget {
  const TileWidget({
    required this.width,
    super.key,
    this.tile,
    this.kind = TileFaceKind.normal,
    this.colorblindGlyph,
    this.selected = false,
    this.highlighted = false,
    this.dimmed = false,
    this.faceDown = false,
  });

  /// Null when [faceDown] is true.
  final Tile? tile;
  final TileFaceKind kind;
  final double width;
  final String? colorblindGlyph;
  final bool selected;
  final bool highlighted;
  final bool dimmed;
  final bool faceDown;

  /// A real okey tile is noticeably taller than it is wide.
  static const double aspectRatio = 1.42;

  static double heightFor(double width) => width * aspectRatio;

  @override
  Widget build(BuildContext context) {
    final effectiveKind = faceDown ? TileFaceKind.back : kind;
    return SizedBox(
      width: width,
      height: heightFor(width),
      child: CustomPaint(
        painter: TilePainter(
          kind: effectiveKind,
          color: tile?.color,
          number: tile?.number,
          colorblindGlyph: effectiveKind == TileFaceKind.back
              ? null
              : colorblindGlyph,
          selected: selected,
          highlighted: highlighted,
          dimmed: dimmed,
        ),
      ),
    );
  }
}
