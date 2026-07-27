import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(historyProvider).reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsExport,
            icon: const Icon(Icons.download),
            onPressed: history.isEmpty ? null : () => _export(context, ref),
          ),
          IconButton(
            tooltip: l10n.historyClear,
            icon: const Icon(Icons.delete_outline),
            onPressed: history.isEmpty ? null : () => _clear(context, ref),
          ),
        ],
      ),
      body: history.isEmpty
          ? Center(
              child: Text(
                l10n.historyEmpty,
                style: const TextStyle(color: OkeyPalette.ivoryShade),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: history.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final record = history[index];
                final date = DateTime.fromMillisecondsSinceEpoch(
                  record.timestampMs,
                );
                final presetLabel = switch (record.preset) {
                  RulePreset.standard => l10n.presetStandard,
                  RulePreset.aggressive => l10n.presetAggressive,
                  RulePreset.custom => l10n.presetCustom,
                };
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${date.day.toString().padLeft(2, '0')}.'
                                '${date.month.toString().padLeft(2, '0')}.'
                                '${date.year}  '
                                '${date.hour.toString().padLeft(2, '0')}:'
                                '${date.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: OkeyPalette.ivoryShade,
                                ),
                              ),
                            ),
                            Text(
                              '$presetLabel  ·  '
                              '${l10n.historyHands(record.handsPlayed)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: OkeyPalette.ivoryShade,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        for (var seat = 0;
                            seat < record.playerNames.length;
                            seat++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                if (seat == record.winnerSeat)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(
                                      Icons.emoji_events,
                                      size: 14,
                                      color: OkeyPalette.brass,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    record.playerNames[seat],
                                    style: TextStyle(
                                      fontWeight: seat == record.winnerSeat
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${record.finalScores[seat]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: record.finalScores[seat] <= 0
                                        ? OkeyPalette.success
                                        : OkeyPalette.ivory,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    await Clipboard.setData(
      ClipboardData(text: ref.read(historyProvider.notifier).exportJson()),
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsExportDone)),
    );
  }

  Future<void> _clear(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.historyClearConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) ref.read(historyProvider.notifier).clear();
  }
}
