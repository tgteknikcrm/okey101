import 'package:okey101/domain/models/scoring.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

/// The corner letter colourblind mode adds to every tile.
///
/// Turkish uses K/S/Y/M (Kirmizi, Sari, Siyah, Mavi). "S" is taken by sari, so
/// black gets Y - that is the K/S/M/Y set real Turkish sets are marked with.
String colorGlyph(AppLocalizations l10n, TileColor color) => switch (color) {
      TileColor.red => l10n.colorGlyphRed,
      TileColor.yellow => l10n.colorGlyphYellow,
      TileColor.black => l10n.colorGlyphBlack,
      TileColor.blue => l10n.colorGlyphBlue,
    };

String colorName(AppLocalizations l10n, TileColor color) => switch (color) {
      TileColor.red => l10n.colorRed,
      TileColor.yellow => l10n.colorYellow,
      TileColor.black => l10n.colorBlack,
      TileColor.blue => l10n.colorBlue,
    };

/// All four glyphs joined, for the colourblind setting's description line.
String allGlyphs(AppLocalizations l10n) => <String>[
      l10n.colorGlyphRed,
      l10n.colorGlyphYellow,
      l10n.colorGlyphBlack,
      l10n.colorGlyphBlue,
    ].join('/');

String finishTypeLabel(AppLocalizations l10n, FinishType? type) =>
    switch (type) {
      null => l10n.finishExhausted,
      FinishType.normal => l10n.finishNormal,
      FinishType.head => l10n.finishHead,
      FinishType.pairs => l10n.finishPairs,
      FinishType.withOkey => l10n.finishWithOkey,
      FinishType.okeyHead => l10n.finishOkeyHead,
      FinishType.pairsWithOkey => l10n.finishPairsWithOkey,
    };

/// A short label for a tile, used in text-only contexts like the debug screen.
String tileLabel(AppLocalizations l10n, Tile tile) {
  if (tile.isFalseJoker) return l10n.gameFalseJoker;
  final identity = tile.printedIdentity!;
  return '${colorGlyph(l10n, identity.color)}${identity.number}';
}

String identityLabel(AppLocalizations l10n, TileIdentity identity) =>
    '${colorGlyph(l10n, identity.color)}${identity.number}';
