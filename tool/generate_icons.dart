// Dependency-free PWA icon generator.
//
// Renders the app icon with a small signed-distance-field rasteriser and writes
// real PNGs by hand (IHDR / IDAT / IEND + CRC32), using only dart:io's zlib.
// No image package, no Flutter, no network.
//
// Run: dart run tool/generate_icons.dart
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const _bgTop = _Rgb(0x1B, 0x5E, 0x43);
const _bgBottom = _Rgb(0x0C, 0x33, 0x26);
const _tileTop = _Rgb(0xFB, 0xF5, 0xE6);
const _tileBottom = _Rgb(0xE4, 0xD6, 0xB4);
const _digitRed = _Rgb(0xC6, 0x28, 0x28);
const _shadow = _Rgb(0x05, 0x1A, 0x14);

void main(List<String> args) {
  final outDir = Directory('web/icons');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  // `any` icons may run edge to edge; maskable icons must keep their content
  // inside the circular 80% safe zone, so the tile is drawn smaller.
  const targets = <_IconSpec>[
    _IconSpec('web/icons/Icon-192.png', 192, 0.74),
    _IconSpec('web/icons/Icon-512.png', 512, 0.74),
    _IconSpec('web/icons/Icon-maskable-192.png', 192, 0.52),
    _IconSpec('web/icons/Icon-maskable-512.png', 512, 0.52),
    _IconSpec('web/icons/apple-touch-icon-180.png', 180, 0.74),
    _IconSpec('web/favicon.png', 64, 0.86),
  ];

  for (final spec in targets) {
    final canvas = _render(spec.size, spec.contentScale);
    final png = _encodePng(spec.size, spec.size, canvas);
    File(spec.path).writeAsBytesSync(png);
    stdout.writeln('wrote ${spec.path} (${spec.size}x${spec.size}, '
        '${png.length} bytes)');
  }
}

class _IconSpec {
  const _IconSpec(this.path, this.size, this.contentScale);

  final String path;
  final int size;
  final double contentScale;
}

class _Rgb {
  const _Rgb(this.r, this.g, this.b);

  final int r;
  final int g;
  final int b;

  static _Rgb lerp(_Rgb a, _Rgb b, double t) => _Rgb(
        (a.r + (b.r - a.r) * t).round(),
        (a.g + (b.g - a.g) * t).round(),
        (a.b + (b.b - a.b) * t).round(),
      );
}

/// Signed distance to a rounded rectangle. Negative inside.
double _sdRoundRect(
  double px,
  double py,
  double cx,
  double cy,
  double hw,
  double hh,
  double r,
) {
  final qx = (px - cx).abs() - (hw - r);
  final qy = (py - cy).abs() - (hh - r);
  final ax = qx > 0 ? qx : 0.0;
  final ay = qy > 0 ? qy : 0.0;
  final outside = math.sqrt(ax * ax + ay * ay);
  final inside = math.min(math.max(qx, qy), 0.0);
  return outside + inside - r;
}

/// Antialiased coverage for a signed distance, in device pixels.
double _coverage(double distance) {
  final v = 0.5 - distance;
  if (v <= 0) return 0;
  if (v >= 1) return 1;
  return v;
}

Uint8List _render(int size, double contentScale) {
  final pixels = Uint8List(size * size * 4);
  final s = size.toDouble();
  final centre = s / 2;

  // Tile geometry.
  final tileHeight = s * contentScale;
  final tileWidth = tileHeight * 0.74;
  final tileRadius = tileWidth * 0.17;
  final tileHalfW = tileWidth / 2;
  final tileHalfH = tileHeight / 2;

  // Digit geometry: "101" laid out across the tile face.
  final digitHeight = tileHeight * 0.44;
  final digitWidth = digitHeight * 0.46;
  final gap = digitWidth * 0.34;
  final totalWidth = digitWidth * 3 + gap * 2;
  final digitTop = centre - digitHeight / 2;
  final firstX = centre - totalWidth / 2;

  for (var y = 0; y < size; y++) {
    final py = y + 0.5;
    for (var x = 0; x < size; x++) {
      final px = x + 0.5;

      // 1. Background gradient, always opaque and full bleed.
      var colour = _Rgb.lerp(_bgTop, _bgBottom, (py / s).clamp(0.0, 1.0));

      // 2. Drop shadow under the tile.
      final shadowDistance = _sdRoundRect(
        px,
        py - s * 0.012,
        centre,
        centre + s * 0.028,
        tileHalfW,
        tileHalfH,
        tileRadius,
      );
      final shadowAlpha = (1.0 - (shadowDistance / (s * 0.05))).clamp(0.0, 1.0);
      if (shadowAlpha > 0) {
        colour = _Rgb.lerp(colour, _shadow, shadowAlpha * 0.55);
      }

      // 3. The ivory tile face.
      final tileDistance = _sdRoundRect(
        px,
        py,
        centre,
        centre,
        tileHalfW,
        tileHalfH,
        tileRadius,
      );
      final tileAlpha = _coverage(tileDistance);
      if (tileAlpha > 0) {
        final t = ((py - (centre - tileHalfH)) / tileHeight).clamp(0.0, 1.0);
        final face = _Rgb.lerp(_tileTop, _tileBottom, t);
        colour = _Rgb.lerp(colour, face, tileAlpha);

        // Bevel highlight along the top edge.
        final bevel = (1.0 - (-tileDistance / (s * 0.02))).clamp(0.0, 1.0);
        if (bevel > 0 && py < centre) {
          colour = _Rgb.lerp(
            colour,
            const _Rgb(0xFF, 0xFF, 0xFF),
            bevel * tileAlpha * 0.35,
          );
        }
      }

      // 4. "101" in okey red.
      var digitAlpha = 0.0;
      for (var d = 0; d < 3; d++) {
        final left = firstX + d * (digitWidth + gap);
        final dc = left + digitWidth / 2;
        final vc = digitTop + digitHeight / 2;
        final glyph = d == 1
            ? _zeroCoverage(px, py, dc, vc, digitWidth, digitHeight)
            : _oneCoverage(px, py, dc, vc, digitWidth, digitHeight);
        if (glyph > digitAlpha) digitAlpha = glyph;
      }
      if (digitAlpha > 0) {
        colour = _Rgb.lerp(colour, _digitRed, digitAlpha * tileAlpha);
      }

      final index = (y * size + x) * 4;
      pixels[index] = colour.r;
      pixels[index + 1] = colour.g;
      pixels[index + 2] = colour.b;
      pixels[index + 3] = 255;
    }
  }
  return pixels;
}

/// A rounded "0": an outer rounded rect minus an inner one.
double _zeroCoverage(
  double px,
  double py,
  double cx,
  double cy,
  double w,
  double h,
) {
  final stroke = w * 0.30;
  final outer = _sdRoundRect(px, py, cx, cy, w / 2, h / 2, w * 0.46);
  final inner = _sdRoundRect(
    px,
    py,
    cx,
    cy,
    w / 2 - stroke,
    h / 2 - stroke,
    (w * 0.46 - stroke).clamp(1.0, double.infinity),
  );
  final outerAlpha = _coverage(outer);
  final innerAlpha = _coverage(inner);
  final result = outerAlpha - innerAlpha;
  return result < 0 ? 0 : result;
}

/// A "1": a vertical stem, an angled-ish flag, and a base serif.
double _oneCoverage(
  double px,
  double py,
  double cx,
  double cy,
  double w,
  double h,
) {
  final stroke = w * 0.30;
  final stem = _sdRoundRect(
    px,
    py,
    cx + w * 0.10,
    cy,
    stroke / 2,
    h / 2,
    stroke * 0.28,
  );
  final flag = _sdRoundRect(
    px,
    py,
    cx - w * 0.06,
    cy - h * 0.36,
    w * 0.24,
    stroke * 0.42,
    stroke * 0.28,
  );
  final base = _sdRoundRect(
    px,
    py,
    cx + w * 0.06,
    cy + h * 0.46,
    w * 0.42,
    stroke * 0.40,
    stroke * 0.28,
  );
  final a = _coverage(stem);
  final b = _coverage(flag);
  final c = _coverage(base);
  return math.max(a, math.max(b, c));
}

// --- PNG encoding ----------------------------------------------------------

Uint8List _encodePng(int width, int height, Uint8List rgba) {
  final raw = BytesBuilder(copy: false);
  for (var y = 0; y < height; y++) {
    raw
      ..addByte(0) // filter type 0 (None)
      ..add(Uint8List.sublistView(rgba, y * width * 4, (y + 1) * width * 4));
  }
  final compressed = ZLibEncoder(level: 9).convert(raw.toBytes());

  final ihdr = BytesBuilder(copy: false)
    ..add(_uint32(width))
    ..add(_uint32(height))
    ..addByte(8) // bit depth
    ..addByte(6) // colour type: RGBA
    ..addByte(0) // compression
    ..addByte(0) // filter
    ..addByte(0); // interlace

  final out = BytesBuilder(copy: false)
    ..add(const <int>[137, 80, 78, 71, 13, 10, 26, 10])
    ..add(_chunk('IHDR', ihdr.toBytes()))
    ..add(_chunk('IDAT', Uint8List.fromList(compressed)))
    ..add(_chunk('IEND', Uint8List(0)));
  return out.toBytes();
}

Uint8List _uint32(int value) {
  final bytes = Uint8List(4);
  bytes[0] = (value >> 24) & 0xFF;
  bytes[1] = (value >> 16) & 0xFF;
  bytes[2] = (value >> 8) & 0xFF;
  bytes[3] = value & 0xFF;
  return bytes;
}

Uint8List _chunk(String type, Uint8List data) {
  final typeBytes = Uint8List.fromList(type.codeUnits);
  final body = BytesBuilder(copy: false)
    ..add(typeBytes)
    ..add(data);
  final bodyBytes = body.toBytes();
  return (BytesBuilder(copy: false)
        ..add(_uint32(data.length))
        ..add(bodyBytes)
        ..add(_uint32(_crc32(bodyBytes))))
      .toBytes();
}

final Uint32List _crcTable = _buildCrcTable();

Uint32List _buildCrcTable() {
  final table = Uint32List(256);
  for (var n = 0; n < 256; n++) {
    var c = n;
    for (var k = 0; k < 8; k++) {
      c = (c & 1) != 0 ? 0xEDB88320 ^ (c >> 1) : c >> 1;
    }
    table[n] = c;
  }
  return table;
}

int _crc32(Uint8List bytes) {
  var c = 0xFFFFFFFF;
  for (final byte in bytes) {
    c = _crcTable[(c ^ byte) & 0xFF] ^ (c >> 8);
  }
  return (c ^ 0xFFFFFFFF) & 0xFFFFFFFF;
}
