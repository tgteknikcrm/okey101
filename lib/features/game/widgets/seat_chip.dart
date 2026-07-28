import 'package:flutter/material.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/widgets/tile_widget.dart';

/// One player around the table: a small circle and a name, nothing more.
///
/// The circle carries the tile count, its ring turns green once that player has
/// opened, and it lights up brass on their turn - three facts in the space a
/// card would have spent on labels.
class SeatChip extends StatelessWidget {
  const SeatChip({
    required this.player,
    required this.isCurrent,
    super.key,
    this.axis = Axis.vertical,
    this.thinking = false,
    this.diameter = 30,
  });

  final PlayerState player;
  final bool isCurrent;

  /// [Axis.horizontal] puts the name beside the circle, for the top of the
  /// table where width is free; [Axis.vertical] stacks it, for the side rails.
  final Axis axis;
  final bool thinking;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final ring = isCurrent
        ? OkeyPalette.brass
        : player.hasOpened
            ? OkeyPalette.success
            : const Color(0x44FBF5E6);

    final circle = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrent
            ? OkeyPalette.brass.withValues(alpha: 0.22)
            : const Color(0x22000000),
        border: Border.all(color: ring, width: isCurrent ? 2 : 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        '${player.hand.length}',
        style: TextStyle(
          fontSize: diameter * 0.42,
          fontWeight: FontWeight.w700,
          color: isCurrent ? OkeyPalette.brass : OkeyPalette.ivory,
          height: 1,
        ),
      ),
    );

    final label = Column(
      crossAxisAlignment:
          axis == Axis.horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          player.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isCurrent ? OkeyPalette.brass : OkeyPalette.ivory,
            height: 1.15,
          ),
        ),
        Text(
          '${player.score}',
          maxLines: 1,
          style: TextStyle(
            fontSize: 10,
            color: player.score <= 0
                ? OkeyPalette.success
                : OkeyPalette.ivoryShade,
            height: 1.15,
          ),
        ),
      ],
    );

    if (axis == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          circle,
          const SizedBox(width: 6),
          Flexible(child: label),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [circle, const SizedBox(height: 2), label],
    );
  }
}

/// The top tile of one player's discard pile, shown at that player's edge of
/// the table the way it sits on a real one.
///
/// The left-hand neighbour's pile is the only one that can be drawn from, so it
/// is the only one that ever becomes tappable.
class DiscardSpot extends StatelessWidget {
  const DiscardSpot({
    required this.tile,
    required this.okey,
    required this.width,
    super.key,
    this.enabled = false,
    this.onTap,
    this.label,
    this.colorblindGlyph,
    this.minTouchSize = 46,
  });

  final Tile? tile;
  final TileIdentity okey;
  final double width;
  final bool enabled;
  final VoidCallback? onTap;
  final String? label;
  final String? colorblindGlyph;

  /// Floor on the tappable box. Generous by default, because a target you
  /// cannot feel has to be; a pile nobody may touch can be smaller.
  final double minTouchSize;

  @override
  Widget build(BuildContext context) {
    final value = tile;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints:
            BoxConstraints(minWidth: minTouchSize, minHeight: minTouchSize),
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: enabled ? OkeyPalette.brass : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value == null)
              _EmptyTile(width: width)
            else
              TileWidget(
                width: width,
                tile: value,
                kind: value.isFalseJoker
                    ? TileFaceKind.falseJoker
                    : (value.color == okey.color && value.number == okey.number)
                        ? TileFaceKind.okey
                        : TileFaceKind.normal,
                colorblindGlyph: colorblindGlyph,
              ),
            if (label != null)
              Text(
                label!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 8,
                  height: 1.2,
                  color:
                      enabled ? OkeyPalette.brass : OkeyPalette.ivoryShade,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTile extends StatelessWidget {
  const _EmptyTile({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: TileWidget.heightFor(width),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0x2AFBF5E6)),
        ),
      );
}
