import 'package:flutter/material.dart';
import 'package:okey101/app/theme.dart';
import 'package:okey101/l10n/generated/app_localizations.dart';

/// The in-app rules, in the player's language.
class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sections = <(String, String)>[
      (l10n.rulesSectionTiles, l10n.rulesTilesBody),
      (l10n.rulesSectionSetup, l10n.rulesSetupBody),
      (l10n.rulesSectionOkey, l10n.rulesOkeyBody),
      (l10n.rulesSectionMelds, l10n.rulesMeldsBody),
      (l10n.rulesSectionOpen, l10n.rulesOpenBody),
      (l10n.rulesSectionPairs, l10n.rulesPairsBody),
      (l10n.rulesSectionTurn, l10n.rulesTurnBody),
      (l10n.rulesSectionFinish, l10n.rulesFinishBody),
      (l10n.rulesSectionScoring, l10n.rulesScoringBody),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.rulesTitle)),
      // Capped so a landscape phone or a wide desktop window does not stretch
      // the prose into unreadably long lines.
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final (title, body) = sections[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: OkeyPalette.brass,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: OkeyPalette.ivory,
                  ),
                ),
              ],
            ),
          );
        },
          ),
        ),
      ),
    );
  }
}
