import 'package:okey101/domain/models/player_view.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// What one bot has actually seen: its own rack, every discard pile, every
/// meld on the table, and the indicator.
///
/// Everything else is either in the draw pile or in somebody's hand, which is
/// exactly the information a human at the table has.
class SeenTiles {
  SeenTiles._(this._seen, this._indicatorIndex, this.hiddenTileCount);

  factory SeenTiles.fromView(PlayerView view) {
    final semantics = TileSemantics(
      indicatorIdentity: view.indicator.printedIdentity!,
      okey: view.okey,
      ruleSet: view.ruleSet,
    );
    final seen = List<int>.filled(52, 0);

    void mark(Tile tile) => seen[semantics.fixedIdentity(tile).index]++;

    mark(view.indicator);
    view.hand.forEach(mark);
    view.ownDiscards.forEach(mark);
    for (final opponent in view.opponents) {
      opponent.discards.forEach(mark);
    }
    for (final meld in view.table) {
      meld.tiles.forEach(mark);
    }

    final hidden = view.drawPileCount +
        view.opponents.fold<int>(0, (sum, o) => sum + o.tileCount);

    return SeenTiles._(
      seen,
      semantics.indicatorIdentity.index,
      hidden,
    );
  }

  final List<int> _seen;
  final int _indicatorIndex;

  /// Tiles that could be anywhere the bot cannot look.
  final int hiddenTileCount;

  /// How many physical tiles carry this identity in a full set.
  ///
  /// Two, except for the indicator's identity: the two false jokers also count
  /// as it, so four tiles share it.
  int totalCopies(TileIdentity identity) =>
      identity.index == _indicatorIndex ? 4 : 2;

  int seenCount(TileIdentity identity) => _seen[identity.index];

  /// Copies the bot has not laid eyes on. They are in the draw pile or in
  /// somebody's hand.
  int unseenCount(TileIdentity identity) {
    final left = totalCopies(identity) - _seen[identity.index];
    return left < 0 ? 0 : left;
  }

  /// Rough chance that at least one copy of [identity] is still gettable.
  ///
  /// Modelled as the share of hidden tiles the unseen copies represent, capped
  /// at 1. It is a heuristic, not a exact probability - the bot has no way to
  /// tell a tile in the pile from one on an opponent's rack.
  double availability(TileIdentity identity) {
    final unseen = unseenCount(identity);
    if (unseen == 0) return 0;
    if (hiddenTileCount <= 0) return 0;
    final chance = unseen / hiddenTileCount * 12.0;
    return chance > 1.0 ? 1.0 : chance;
  }

  /// True when every copy of [identity] is already accounted for, so waiting
  /// for one is pointless.
  bool isDead(TileIdentity identity) => unseenCount(identity) == 0;
}
