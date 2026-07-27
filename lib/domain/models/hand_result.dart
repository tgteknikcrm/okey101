import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/scoring.dart';

part 'hand_result.freezed.dart';
part 'hand_result.g.dart';

/// One player's line on the scoreboard ("cetele") for a finished hand.
@freezed
abstract class PlayerHandResult with _$PlayerHandResult {
  const PlayerHandResult._();

  const factory PlayerHandResult({
    required int seat,

    /// Face value of the tiles left on the rack. Zero for the winner.
    required int deadwood,
    required bool hasOpened,

    /// Points written for this hand. Negative for the winner.
    required int delta,

    /// Cumulative score after this hand.
    required int total,
  }) = _PlayerHandResult;

  factory PlayerHandResult.fromJson(Map<String, dynamic> json) =>
      _$PlayerHandResultFromJson(json);
}

/// The outcome of one hand ("el").
@freezed
abstract class HandResult with _$HandResult {
  const HandResult._();

  const factory HandResult({
    required int handNumber,

    /// Null when the draw pile ran out with nobody going out.
    required int? winnerSeat,
    required FinishType? finishType,
    required ScoreRowKey rowKey,
    required List<PlayerHandResult> players,
  }) = _HandResult;

  factory HandResult.fromJson(Map<String, dynamic> json) =>
      _$HandResultFromJson(json);

  bool get deckExhausted => winnerSeat == null;
}

/// A finished match, as stored in the history list.
@freezed
abstract class MatchRecord with _$MatchRecord {
  const MatchRecord._();

  const factory MatchRecord({
    required String id,

    /// Milliseconds since epoch. Supplied by the caller - the domain never
    /// reads the clock itself.
    required int timestampMs,
    required List<String> playerNames,
    required List<int> finalScores,
    required int winnerSeat,
    required int handsPlayed,
    required RulePreset preset,
  }) = _MatchRecord;

  factory MatchRecord.fromJson(Map<String, dynamic> json) =>
      _$MatchRecordFromJson(json);
}
