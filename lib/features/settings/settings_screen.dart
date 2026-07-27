import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okey101/app/providers.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/core/tile_glyphs.dart';
import 'package:okey101/domain/ai/bot_brain.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/scoring.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

/// Every rule and every scoring number is editable here, with no rebuild.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final rules = settings.ruleSet;

    void updateRules(RuleSet Function(RuleSet) change) {
      final next = change(rules);
      // Any hand edit makes the set custom, so a preset badge never lies.
      notifier.setRuleSet(
        next.preset == RulePreset.custom
            ? next
            : next.copyWith(preset: RulePreset.custom),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 40),
        children: [
          _SectionTitle(l10n.settingsGeneral),
          _ChoiceTile<String>(
            title: l10n.settingsLanguage,
            value: settings.languageCode,
            options: {
              'tr': l10n.settingsLanguageTurkish,
              'en': l10n.settingsLanguageEnglish,
            },
            onChanged: notifier.setLanguage,
          ),
          SwitchListTile(
            title: Text(l10n.settingsColorblind),
            subtitle: Text(l10n.settingsColorblindDesc(allGlyphs(l10n))),
            value: settings.colorblind,
            onChanged: (value) =>
                notifier.update((s) => s.copyWith(colorblind: value)),
          ),
          SwitchListTile(
            title: Text(l10n.settingsFastMode),
            subtitle: Text(l10n.settingsFastModeDesc),
            value: settings.fastMode,
            onChanged: (value) =>
                notifier.update((s) => s.copyWith(fastMode: value)),
          ),
          SwitchListTile(
            title: Text(l10n.settingsAnimations),
            subtitle: Text(l10n.settingsAnimationsDesc),
            value: settings.animations,
            onChanged: (value) =>
                notifier.update((s) => s.copyWith(animations: value)),
          ),
          SwitchListTile(
            title: Text(l10n.settingsKeepAwake),
            value: settings.keepScreenAwake,
            onChanged: (value) =>
                notifier.update((s) => s.copyWith(keepScreenAwake: value)),
          ),
          _ChoiceTile<BotDifficulty>(
            title: l10n.settingsPreset,
            value: settings.difficulty,
            options: const {
              BotDifficulty.easy: 'Kolay / Easy',
              BotDifficulty.medium: 'Orta / Medium',
              BotDifficulty.hard: 'Zor / Hard',
            },
            onChanged: (value) =>
                notifier.update((s) => s.copyWith(difficulty: value)),
          ),

          _SectionTitle(l10n.settingsRules),
          _ChoiceTile<RulePreset>(
            title: l10n.settingsPreset,
            value: rules.preset,
            options: {
              RulePreset.standard: l10n.presetStandard,
              RulePreset.aggressive: l10n.presetAggressive,
              RulePreset.custom: l10n.presetCustom,
            },
            onChanged: (preset) {
              if (preset == RulePreset.custom) {
                notifier.setRuleSet(rules.copyWith(preset: RulePreset.custom));
              } else {
                notifier.setRuleSet(RulePresets.of(preset));
              }
            },
          ),
          _NumberTile(
            title: l10n.settingsOpenThreshold,
            value: rules.openThreshold,
            min: 51,
            max: 151,
            step: 1,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(openThreshold: value)),
          ),
          SwitchListTile(
            title: Text(l10n.settingsEscalatingOpen),
            subtitle: Text(l10n.settingsEscalatingOpenDesc),
            value: rules.escalatingOpenThreshold,
            onChanged: (value) => updateRules(
              (r) => r.copyWith(escalatingOpenThreshold: value),
            ),
          ),
          SwitchListTile(
            title: Text(l10n.settingsAllowCircularRuns),
            value: rules.allowCircularRuns,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(allowCircularRuns: value)),
          ),
          _NumberTile(
            title: l10n.settingsMaxRunLength,
            value: rules.maxRunLengthOnLayDown,
            min: 3,
            max: 13,
            step: 1,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(maxRunLengthOnLayDown: value)),
          ),
          _NumberTile(
            title: l10n.settingsMaxJokers,
            value: rules.maxJokersPerMeld,
            min: 0,
            max: 2,
            step: 1,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(maxJokersPerMeld: value)),
          ),
          _NumberTile(
            title: l10n.settingsMinPairsToOpen,
            value: rules.minPairsToOpen,
            min: 3,
            max: 11,
            step: 1,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(minPairsToOpen: value)),
          ),
          _NumberTile(
            title: l10n.settingsPairsToFinish,
            value: rules.pairsToFinish,
            min: 5,
            max: 11,
            step: 1,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(pairsToFinish: value)),
          ),
          SwitchListTile(
            title: Text(l10n.settingsCanLayNewMelds),
            value: rules.canLayNewMeldsAfterOpening,
            onChanged: (value) => updateRules(
              (r) => r.copyWith(canLayNewMeldsAfterOpening: value),
            ),
          ),
          SwitchListTile(
            title: Text(l10n.settingsCanReplaceJoker),
            value: rules.canReplaceJokerOnTable,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(canReplaceJokerOnTable: value)),
          ),
          SwitchListTile(
            title: Text(l10n.settingsCanTakeDiscardBeforeOpening),
            value: rules.canTakeDiscardBeforeOpening,
            onChanged: (value) => updateRules(
              (r) => r.copyWith(canTakeDiscardBeforeOpening: value),
            ),
          ),
          _NumberTile(
            title: l10n.settingsOkeyDeadwoodValue,
            value: rules.okeyDeadwoodValue,
            min: 0,
            max: 101,
            step: 5,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(okeyDeadwoodValue: value)),
          ),
          _ChoiceTile<DeckExhaustedPolicy>(
            title: l10n.settingsOnDeckExhausted,
            value: rules.onDeckExhausted,
            options: {
              DeckExhaustedPolicy.scoreDeadwood:
                  l10n.deckExhaustedScoreDeadwood,
              DeckExhaustedPolicy.voidHand: l10n.deckExhaustedVoid,
            },
            onChanged: (value) =>
                updateRules((r) => r.copyWith(onDeckExhausted: value)),
          ),
          _ChoiceTile<StartingPlayerRotation>(
            title: l10n.settingsStartingPlayer,
            value: rules.startingPlayerRotation,
            options: {
              StartingPlayerRotation.rotate: l10n.startingRotate,
              StartingPlayerRotation.fixed: l10n.startingFixed,
              StartingPlayerRotation.seededRandom: l10n.startingRandom,
            },
            onChanged: (value) =>
                updateRules((r) => r.copyWith(startingPlayerRotation: value)),
          ),
          _ChoiceTile<FalseJokerIndicatorPolicy>(
            title: l10n.settingsFalseJokerIndicator,
            value: rules.falseJokerAsIndicator,
            options: {
              FalseJokerIndicatorPolicy.reshuffle: l10n.falseJokerReshuffle,
              FalseJokerIndicatorPolicy.drawNext: l10n.falseJokerDrawNext,
            },
            onChanged: (value) =>
                updateRules((r) => r.copyWith(falseJokerAsIndicator: value)),
          ),
          _NumberTile(
            title: l10n.settingsHandsPerMatch,
            value: rules.handsPerMatch,
            min: 1,
            max: 31,
            step: 1,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(handsPerMatch: value)),
          ),
          _NumberTile(
            title: l10n.settingsTargetScore,
            value: rules.targetScore,
            min: -2000,
            max: 0,
            step: 50,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(targetScore: value)),
          ),
          _ChoiceTile<MatchEndMode>(
            title: l10n.settingsMatchEndMode,
            value: rules.matchEndMode,
            options: {
              MatchEndMode.handsOnly: l10n.matchEndHands,
              MatchEndMode.targetOnly: l10n.matchEndTarget,
              MatchEndMode.both: l10n.matchEndBoth,
            },
            onChanged: (value) =>
                updateRules((r) => r.copyWith(matchEndMode: value)),
          ),
          _NumberTile(
            title: l10n.settingsIllegalOpenPenalty,
            value: rules.illegalOpenPenalty,
            min: 0,
            max: 505,
            step: 1,
            onChanged: (value) =>
                updateRules((r) => r.copyWith(illegalOpenPenalty: value)),
          ),

          _SectionTitle(l10n.settingsScoring),
          _ScoringTable(
            table: rules.scoringTable,
            onEditRow: (key) => _editScoringRow(context, ref, rules, key),
          ),

          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: notifier.resetRules,
            icon: const Icon(Icons.restore),
            label: Text(l10n.settingsResetRules),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _exportHistory(context, ref),
            icon: const Icon(Icons.download),
            label: Text(l10n.settingsExport),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _resetEverything(context, ref),
            icon: const Icon(Icons.delete_outline, color: OkeyPalette.danger),
            label: Text(
              l10n.settingsResetAll,
              style: const TextStyle(color: OkeyPalette.danger),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              l10n.settingsVersion('1.0.0'),
              style: const TextStyle(
                fontSize: 11,
                color: OkeyPalette.ivoryShade,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Edits one row of the scoring table in place, so every number in the game
  /// is reachable without a rebuild.
  Future<void> _editScoringRow(
    BuildContext context,
    WidgetRef ref,
    RuleSet rules,
    ScoreRowKey key,
  ) async {
    final edited = await showDialog<ScoringRow>(
      context: context,
      builder: (context) => _ScoringRowDialog(
        rowKey: key,
        row: rules.scoringTable.rowFor(key),
      ),
    );
    if (edited == null) return;
    final table = rules.scoringTable;
    final next = switch (key) {
      ScoreRowKey.normal => table.copyWith(normal: edited),
      ScoreRowKey.head => table.copyWith(head: edited),
      ScoreRowKey.pairs => table.copyWith(pairs: edited),
      ScoreRowKey.withOkey => table.copyWith(withOkey: edited),
      ScoreRowKey.okeyHead => table.copyWith(okeyHead: edited),
      ScoreRowKey.pairsWithOkey => table.copyWith(pairsWithOkey: edited),
      ScoreRowKey.exhausted => table.copyWith(exhausted: edited),
    };
    ref.read(settingsProvider.notifier).setRuleSet(
          rules.copyWith(scoringTable: next, preset: RulePreset.custom),
        );
  }

  Future<void> _exportHistory(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final json = ref.read(historyProvider.notifier).exportJson();
    await Clipboard.setData(ClipboardData(text: json));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsExportDone)),
    );
  }

  Future<void> _resetEverything(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.settingsResetAllConfirm),
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
    if (confirmed != true) return;
    await ref.read(localStoreProvider).clearEverything();
    ref.read(historyProvider.notifier).clear();
    ref.read(settingsProvider.notifier).resetAll();
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 22, 4, 6),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
            color: OkeyPalette.brass,
          ),
        ),
      );
}

class _ChoiceTile<T> extends StatelessWidget {
  const _ChoiceTile({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<T>(
        value: value,
        underline: const SizedBox.shrink(),
        dropdownColor: OkeyPalette.felt,
        items: [
          for (final entry in options.entries)
            DropdownMenuItem<T>(value: entry.key, child: Text(entry.value)),
        ],
        onChanged: (next) {
          if (next != null) onChanged(next);
        },
      ),
    );
  }
}

class _NumberTile extends StatelessWidget {
  const _NumberTile({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  final String title;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 22,
            onPressed: value - step >= min ? () => onChanged(value - step) : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          SizedBox(
            width: 52,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            iconSize: 22,
            onPressed: value + step <= max ? () => onChanged(value + step) : null,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}

class _ScoringTable extends StatelessWidget {
  const _ScoringTable({required this.table, required this.onEditRow});

  final ScoringTable table;
  final ValueChanged<ScoreRowKey> onEditRow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String penalty(OpponentPenalty value) => switch (value) {
          DeadwoodMultiple(:final multiplier) =>
            l10n.scoringMultiplier(multiplier),
          FlatPenalty(:final points) => l10n.scoringFlat(points),
        };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(flex: 3, child: SizedBox.shrink()),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.scoringWinner,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.scoringOpened,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.scoringNotOpened,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
            const Divider(),
            for (final key in ScoreRowKey.values)
              InkWell(
                onTap: () => onEditRow(key),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          scoreRowLabel(l10n, key),
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${table.rowFor(key).winnerPoints ?? '-'}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          penalty(table.rowFor(key).opened),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          penalty(table.rowFor(key).notOpened),
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      const Icon(Icons.edit, size: 12),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Edits one scoring row: the winner's points and both opponent penalties.
class _ScoringRowDialog extends StatefulWidget {
  const _ScoringRowDialog({required this.rowKey, required this.row});

  final ScoreRowKey rowKey;
  final ScoringRow row;

  @override
  State<_ScoringRowDialog> createState() => _ScoringRowDialogState();
}

class _ScoringRowDialogState extends State<_ScoringRowDialog> {
  late int _winner = widget.row.winnerPoints ?? 0;

  /// The exhausted-deck row has no winner, so its bonus stays absent.
  late final bool _hasWinnerPoints = widget.row.winnerPoints != null;
  late OpponentPenalty _opened = widget.row.opened;
  late OpponentPenalty _notOpened = widget.row.notOpened;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(scoreRowLabel(l10n, widget.rowKey)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_hasWinnerPoints)
              _NumberTile(
                title: l10n.scoringWinner,
                value: _winner,
                min: -2020,
                max: 0,
                step: 101,
                onChanged: (value) => setState(() => _winner = value),
              )
            else
              ListTile(
                title: Text(l10n.scoringWinner),
                trailing: const Text('-'),
                subtitle: Text(l10n.handOverNoWinner),
              ),
            const Divider(),
            _PenaltyEditor(
              title: l10n.scoringOpened,
              value: _opened,
              onChanged: (value) => setState(() => _opened = value),
            ),
            const Divider(),
            _PenaltyEditor(
              title: l10n.scoringNotOpened,
              value: _notOpened,
              onChanged: (value) => setState(() => _notOpened = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(
            ScoringRow(
              winnerPoints: _hasWinnerPoints ? _winner : null,
              opened: _opened,
              notOpened: _notOpened,
            ),
          ),
          child: Text(l10n.commonSave),
        ),
      ],
    );
  }
}

class _PenaltyEditor extends StatelessWidget {
  const _PenaltyEditor({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final OpponentPenalty value;
  final ValueChanged<OpponentPenalty> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isFlat = value is FlatPenalty;
    final number = switch (value) {
      DeadwoodMultiple(:final multiplier) => multiplier,
      FlatPenalty(:final points) => points,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChoiceTile<bool>(
          title: title,
          value: isFlat,
          options: {
            false: l10n.scoringMultiplier(number.clamp(1, 99)),
            true: l10n.scoringFlat(number),
          },
          onChanged: (flat) => onChanged(
            flat
                ? OpponentPenalty.flat(points: number < 4 ? number * 101 : number)
                : OpponentPenalty.deadwoodMultiple(
                    multiplier: number > 8 ? 1 : number,
                  ),
          ),
        ),
        _NumberTile(
          title: isFlat ? l10n.scoringFlat(number) : l10n.scoringMultiplier(number),
          value: number,
          min: isFlat ? 0 : 1,
          max: isFlat ? 2020 : 8,
          step: isFlat ? 101 : 1,
          onChanged: (next) => onChanged(
            isFlat
                ? OpponentPenalty.flat(points: next)
                : OpponentPenalty.deadwoodMultiple(multiplier: next),
          ),
        ),
      ],
    );
  }
}

/// Label for a scoring row, including the exhausted-deck case that has no
/// matching finish type.
String scoreRowLabel(AppLocalizations l10n, ScoreRowKey key) =>
    finishTypeLabel(
      l10n,
      key == ScoreRowKey.exhausted
          ? null
          : FinishType.values.firstWhere((t) => t.name == key.name),
    );
