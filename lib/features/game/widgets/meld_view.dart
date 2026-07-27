import 'package:flutter/material.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/widgets/tile_widget.dart';

/// One meld sitting on the table.
class MeldView extends StatelessWidget {
  const MeldView({
    required this.meld,
    required this.okey,
    required this.ownerName,
    required this.tileWidth,
    super.key,
    this.colorblind = false,
    this.glyphFor,
    this.highlighted = false,
    this.onTap,
    this.onTapTile,
  });

  final Meld meld;
  final TileIdentity okey;
  final String ownerName;
  final double tileWidth;
  final bool colorblind;
  final String Function(TileColor)? glyphFor;
  final bool highlighted;
  final VoidCallback? onTap;

  /// Index of the tapped position, used to swap a joker off the table.
  final ValueChanged<int>? onTapTile;

  bool _isOkey(Tile tile) =>
      !tile.isFalseJoker &&
      tile.color == okey.color &&
      tile.number == okey.number;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(5, 4, 5, 3),
        decoration: BoxDecoration(
          color: highlighted
              ? OkeyPalette.brass.withValues(alpha: 0.22)
              : const Color(0x22000000),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: highlighted
                ? OkeyPalette.brass
                : const Color(0x33FBF5E6),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < meld.tiles.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: GestureDetector(
                      onTap: onTapTile == null ? null : () => onTapTile!(i),
                      child: TileWidget(
                        width: tileWidth,
                        tile: meld.tiles[i],
                        kind: meld.tiles[i].isFalseJoker
                            ? TileFaceKind.falseJoker
                            : _isOkey(meld.tiles[i])
                                ? TileFaceKind.okey
                                : TileFaceKind.normal,
                        colorblindGlyph:
                            colorblind && meld.tiles[i].color != null
                                ? glyphFor?.call(meld.tiles[i].color!)
                                : null,
                        highlighted: meld.jokerAssignments[i] != null,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 1),
              child: Text(
                ownerName,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xAAFBF5E6),
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
