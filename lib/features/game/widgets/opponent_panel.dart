import 'package:flutter/material.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/domain/models/game_state.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/features/game/widgets/tile_widget.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

/// One opponent: name, how many tiles they hold, whether they have opened,
/// their running score, and the top of their discard pile.
class OpponentPanel extends StatelessWidget {
  const OpponentPanel({
    required this.player,
    required this.isCurrent,
    required this.okey,
    super.key,
    this.thinking = false,
    this.compact = false,
  });

  final PlayerState player;
  final bool isCurrent;
  final bool thinking;
  final TileIdentity okey;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final top = player.topDiscard;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isCurrent
            ? OkeyPalette.brass.withValues(alpha: 0.18)
            : const Color(0x1AFBF5E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? OkeyPalette.brass : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            player.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isCurrent ? OkeyPalette.brass : OkeyPalette.ivory,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.style_outlined,
                size: 11,
                color: OkeyPalette.ivoryShade,
              ),
              const SizedBox(width: 2),
              Text(
                '${player.hand.length}',
                style: const TextStyle(
                  fontSize: 11,
                  color: OkeyPalette.ivoryShade,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${player.score}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: player.score <= 0
                      ? OkeyPalette.success
                      : OkeyPalette.ivoryShade,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: player.hasOpened
                  ? OkeyPalette.success.withValues(alpha: 0.25)
                  : const Color(0x22000000),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              player.hasOpened
                  ? l10n.gameOpenedBadge
                  : l10n.gameNotOpenedBadge,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: player.hasOpened
                    ? OkeyPalette.success
                    : OkeyPalette.ivoryShade,
              ),
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: 4),
            SizedBox(
              height: TileWidget.heightFor(20),
              child: top == null
                  ? const SizedBox.shrink()
                  : TileWidget(
                      width: 20,
                      tile: top,
                      kind: top.isFalseJoker
                          ? TileFaceKind.falseJoker
                          : (top.color == okey.color && top.number == okey.number)
                              ? TileFaceKind.okey
                              : TileFaceKind.normal,
                    ),
            ),
          ],
          if (thinking && isCurrent)
            const Padding(
              padding: EdgeInsets.only(top: 3),
              child: SizedBox(
                width: 26,
                height: 2,
                child: LinearProgressIndicator(
                  minHeight: 2,
                  color: OkeyPalette.brass,
                  backgroundColor: Color(0x33FBF5E6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
