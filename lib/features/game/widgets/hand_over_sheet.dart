import 'package:flutter/material.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/core/tile_glyphs.dart';
import 'package:okey101/domain/engine/score_calculator.dart';
import 'package:okey101/features/game/game_session.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

/// End-of-hand and end-of-match panel: finish type, the per-player breakdown,
/// and the running scoreboard.
class HandOverSheet extends StatelessWidget {
  const HandOverSheet({
    required this.session,
    required this.onNextHand,
    required this.onLeave,
    super.key,
  });

  final GameSession session;
  final VoidCallback onNextHand;
  final VoidCallback onLeave;

  /// Penalties read better with an explicit sign; the winner's is negative.
  static String _signed(int value) => value > 0 ? '+$value' : '$value';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final game = session.state;
    final result = game.handResult;
    if (result == null) return const SizedBox.shrink();

    final matchOver = game.isMatchOver;
    final winnerName = result.winnerSeat == null
        ? null
        : game.players[result.winnerSeat!].name;

    return ColoredBox(
      color: const Color(0xCC061F17),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          // Without a cap the card stretches the full landscape width and the
          // scoreboard columns drift apart.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    matchOver ? l10n.matchOverTitle : l10n.handOverTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: OkeyPalette.brass,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (winnerName == null)
                    Text(
                      l10n.handOverNoWinner,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    )
                  else
                    Text(
                      l10n.handOverWinner(
                        winnerName,
                        finishTypeLabel(l10n, result.finishType),
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                  const SizedBox(height: 14),
                  _Row(
                    cells: [
                      '',
                      l10n.handOverDeadwood,
                      l10n.handOverDelta,
                      l10n.handOverTotal,
                    ],
                    header: true,
                  ),
                  const Divider(),
                  for (final line in result.players)
                    _Row(
                      cells: [
                        game.players[line.seat].name,
                        '${line.deadwood}',
                        _signed(line.delta),
                        '${line.total}',
                      ],
                      highlight: line.seat == result.winnerSeat,
                    ),
                  if (matchOver) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.matchOverWinner(
                        game
                            .players[
                                ScoreCalculator.matchWinner(
                                  game.players.map((p) => p.score).toList(),
                                )]
                            .name,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: OkeyPalette.success,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (matchOver)
                    FilledButton(
                      onPressed: onLeave,
                      child: Text(l10n.matchOverToMenu),
                    )
                  else
                    FilledButton.icon(
                      onPressed: onNextHand,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(l10n.handOverNext),
                    ),
                ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.cells,
    this.header = false,
    this.highlight = false,
  });

  final List<String> cells;
  final bool header;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: header ? 11 : 13,
      fontWeight: header || highlight ? FontWeight.bold : FontWeight.normal,
      color: highlight ? OkeyPalette.success : OkeyPalette.ivory,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(cells[0], style: style)),
          Expanded(
            child: Text(cells[1], textAlign: TextAlign.right, style: style),
          ),
          Expanded(
            child: Text(cells[2], textAlign: TextAlign.right, style: style),
          ),
          Expanded(
            child: Text(cells[3], textAlign: TextAlign.right, style: style),
          ),
        ],
      ),
    );
  }
}
