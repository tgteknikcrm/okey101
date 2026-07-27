import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/rule_set.dart';

part 'game_log.freezed.dart';
part 'game_log.g.dart';

/// The replay log for a match.
///
/// Only engine-meaningful actions live here. Rack reordering and other
/// presentation state is a `UiAction` in the UI layer: rack order is saved so a
/// restored game looks the way the player left it, but it is deliberately not
/// part of replay - including it would bloat the log with noise that has no
/// effect on the game.
@freezed
abstract class GameLog with _$GameLog {
  const GameLog._();

  const factory GameLog({
    required int seed,
    required RuleSet ruleSet,
    required List<String> playerNames,
    @Default(<GameAction>[]) List<GameAction> canonicalActions,
  }) = _GameLog;

  factory GameLog.fromJson(Map<String, dynamic> json) =>
      _$GameLogFromJson(json);

  GameLog record(GameAction action) =>
      copyWith(canonicalActions: [...canonicalActions, action]);

  int get length => canonicalActions.length;
}
