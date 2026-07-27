import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:okey101/domain/models/meld.dart';

part 'game_action.freezed.dart';
part 'game_action.g.dart';

/// Everything a player - human or bot - can ask the engine to do.
///
/// These are the *canonical* actions: they are the replay log. Rack reordering
/// and other presentation-only state lives in `UiAction` and is deliberately
/// not part of this union, because including it would bloat the log with noise
/// that has no effect on the game.
@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.snake)
sealed class GameAction with _$GameAction {
  const GameAction._();

  /// Draw the top tile of the face-down pile.
  const factory GameAction.drawFromPile() = DrawFromPile;

  /// Draw the top tile of the LEFT-hand neighbour's discard pile.
  const factory GameAction.drawFromDiscard() = DrawFromDiscard;

  /// Discard to your own pile and end the turn.
  const factory GameAction.discard({required int tileId}) = DiscardTile;

  /// Lay the opening melds, all in one turn, totalling at least the threshold.
  const factory GameAction.open({required List<MeldProposal> melds}) =
      OpenWithMelds;

  /// Lay pairs. The first call opens on the pairs path and must carry at least
  /// `minPairsToOpen` pairs; later calls extend it. Laying the last pair of
  /// `pairsToFinish` from a full hand finishes without a discard.
  const factory GameAction.layPairs({required List<MeldProposal> pairs}) =
      LayPairs;

  /// Lay an additional meld after having opened.
  const factory GameAction.layMeld({required MeldProposal meld}) = LayNewMeld;

  /// "Islemek": extend a meld already on the table, anyone's included.
  const factory GameAction.addToMeld({
    required int meldId,
    required int tileId,
    @Default(false) bool atStart,
  }) = AddToMeld;

  /// Swap the real tile in for a wild okey sitting on the table and take the
  /// okey into hand. You are not required to use it that turn.
  const factory GameAction.replaceJoker({
    required int meldId,
    required int index,
    required int tileId,
  }) = ReplaceJoker;

  /// Deal the next hand once the current one is over.
  const factory GameAction.startNextHand() = StartNextHand;

  factory GameAction.fromJson(Map<String, dynamic> json) =>
      _$GameActionFromJson(json);
}
