import 'package:freezed_annotation/freezed_annotation.dart';

part 'scoring.freezed.dart';
part 'scoring.g.dart';

/// How a hand ended for the player who went out.
enum FinishType {
  /// Opened on an earlier turn, then discards the last tile.
  normal,

  /// "Kafa": opens and finishes in a single turn from a full 22-tile hand,
  /// never having opened before. The 101 threshold still applies.
  head,

  /// "Ciftten bitis": finished via the 11-pairs path.
  pairs,

  /// The final discarded tile was the okey.
  withOkey,

  /// A [head] finish whose final discard was the okey.
  okeyHead,

  /// A [pairs] finish where the okey completed the 11th pair.
  pairsWithOkey,
}

/// Row selector for [ScoringTable]. Mirrors [FinishType] plus the case where
/// the draw pile ran out and nobody went out at all.
enum ScoreRowKey {
  normal,
  head,
  pairs,
  withOkey,
  okeyHead,
  pairsWithOkey,
  exhausted;

  static ScoreRowKey fromFinishType(FinishType type) => switch (type) {
        FinishType.normal => ScoreRowKey.normal,
        FinishType.head => ScoreRowKey.head,
        FinishType.pairs => ScoreRowKey.pairs,
        FinishType.withOkey => ScoreRowKey.withOkey,
        FinishType.okeyHead => ScoreRowKey.okeyHead,
        FinishType.pairsWithOkey => ScoreRowKey.pairsWithOkey,
      };
}

/// Penalties are modelled as data, not as conditionals: an opponent either
/// writes a multiple of their deadwood, or a flat number independent of what is
/// left on their rack.
@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.snake)
sealed class OpponentPenalty with _$OpponentPenalty {
  const OpponentPenalty._();

  /// Deadwood face value multiplied by [multiplier].
  const factory OpponentPenalty.deadwoodMultiple({
    required int multiplier,
  }) = DeadwoodMultiple;

  /// A flat penalty, independent of the tiles left in hand.
  const factory OpponentPenalty.flat({required int points}) = FlatPenalty;

  factory OpponentPenalty.fromJson(Map<String, dynamic> json) =>
      _$OpponentPenaltyFromJson(json);

  /// Applies this penalty to a player whose remaining tiles are worth
  /// [deadwood] face value.
  int apply(int deadwood) => switch (this) {
        DeadwoodMultiple(:final multiplier) => deadwood * multiplier,
        FlatPenalty(:final points) => points,
      };

  /// Returns the same penalty with every number doubled.
  OpponentPenalty get doubled => switch (this) {
        DeadwoodMultiple(:final multiplier) =>
          OpponentPenalty.deadwoodMultiple(multiplier: multiplier * 2),
        FlatPenalty(:final points) => OpponentPenalty.flat(points: points * 2),
      };
}

/// One row of the scoring table.
///
/// [winnerPoints] is null for the exhausted-deck row, where there is no winner
/// and therefore no winner bonus to apply.
@freezed
abstract class ScoringRow with _$ScoringRow {
  const ScoringRow._();

  const factory ScoringRow({
    required int? winnerPoints,
    required OpponentPenalty opened,
    required OpponentPenalty notOpened,
  }) = _ScoringRow;

  factory ScoringRow.fromJson(Map<String, dynamic> json) =>
      _$ScoringRowFromJson(json);

  ScoringRow get doubled => ScoringRow(
        winnerPoints: winnerPoints == null ? null : winnerPoints! * 2,
        opened: opened.doubled,
        notOpened: notOpened.doubled,
      );
}

/// The full scoring table. Rows are explicit fields rather than a map so the
/// shape is type-checked and the JSON round-trip has no enum-key edge cases.
@freezed
abstract class ScoringTable with _$ScoringTable {
  const ScoringTable._();

  const factory ScoringTable({
    @Default(
      ScoringRow(
        winnerPoints: -101,
        opened: OpponentPenalty.deadwoodMultiple(multiplier: 1),
        notOpened: OpponentPenalty.flat(points: 202),
      ),
    )
    ScoringRow normal,
    @Default(
      ScoringRow(
        winnerPoints: -202,
        opened: OpponentPenalty.deadwoodMultiple(multiplier: 1),
        notOpened: OpponentPenalty.flat(points: 404),
      ),
    )
    ScoringRow head,
    @Default(
      ScoringRow(
        winnerPoints: -202,
        opened: OpponentPenalty.deadwoodMultiple(multiplier: 2),
        notOpened: OpponentPenalty.flat(points: 404),
      ),
    )
    ScoringRow pairs,
    @Default(
      ScoringRow(
        winnerPoints: -202,
        opened: OpponentPenalty.deadwoodMultiple(multiplier: 2),
        notOpened: OpponentPenalty.flat(points: 404),
      ),
    )
    ScoringRow withOkey,
    @Default(
      ScoringRow(
        winnerPoints: -404,
        opened: OpponentPenalty.deadwoodMultiple(multiplier: 2),
        notOpened: OpponentPenalty.flat(points: 808),
      ),
    )
    ScoringRow okeyHead,
    @Default(
      ScoringRow(
        winnerPoints: -404,
        opened: OpponentPenalty.deadwoodMultiple(multiplier: 4),
        notOpened: OpponentPenalty.flat(points: 808),
      ),
    )
    ScoringRow pairsWithOkey,

    /// Draw pile exhausted with nobody going out. There is no winner, so no
    /// winner bonus; and because the flat never-opened penalty is the price of
    /// failing to open *while someone else won*, with no winner there is nobody
    /// to have lost to. Everyone simply writes their deadwood once. Modelling
    /// it as a row is what removes the `if` from ScoreCalculator.
    @Default(
      ScoringRow(
        winnerPoints: null,
        opened: OpponentPenalty.deadwoodMultiple(multiplier: 1),
        notOpened: OpponentPenalty.deadwoodMultiple(multiplier: 1),
      ),
    )
    ScoringRow exhausted,
  }) = _ScoringTable;

  factory ScoringTable.fromJson(Map<String, dynamic> json) =>
      _$ScoringTableFromJson(json);

  ScoringRow rowFor(ScoreRowKey key) => switch (key) {
        ScoreRowKey.normal => normal,
        ScoreRowKey.head => head,
        ScoreRowKey.pairs => pairs,
        ScoreRowKey.withOkey => withOkey,
        ScoreRowKey.okeyHead => okeyHead,
        ScoreRowKey.pairsWithOkey => pairsWithOkey,
        ScoreRowKey.exhausted => exhausted,
      };

  /// The `Aggressive` preset: every penalty and bonus doubled.
  ScoringTable get doubled => ScoringTable(
        normal: normal.doubled,
        head: head.doubled,
        pairs: pairs.doubled,
        withOkey: withOkey.doubled,
        okeyHead: okeyHead.doubled,
        pairsWithOkey: pairsWithOkey.doubled,
        exhausted: exhausted.doubled,
      );
}
