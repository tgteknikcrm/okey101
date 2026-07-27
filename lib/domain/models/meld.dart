import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:okey101/domain/models/tile.dart';

part 'meld.freezed.dart';
part 'meld.g.dart';

enum MeldKind {
  /// "Seri": same colour, consecutive numbers, 3+ tiles, never circular.
  run,

  /// "Per": same number, all different colours, 3 or 4 tiles.
  set,

  /// "Cift": two tiles of the same colour AND number. Only ever laid by a
  /// player on the pairs path.
  pair,
}

/// A meld sitting on the table.
///
/// [tiles] is kept in laid-down order on purpose. A wild's identity comes from
/// its ordered position - a joker between 5 and 7 can only be 6 - so an
/// unordered multiset would be ambiguous.
@freezed
abstract class Meld with _$Meld {
  const Meld._();

  const factory Meld({
    required int id,
    required MeldKind kind,
    required int ownerSeat,
    required List<Tile> tiles,

    /// Index-parallel with [tiles]. Non-null exactly at the positions holding a
    /// wild okey, recording what that okey was laid down as. This is what
    /// drives scoring and joker replacement.
    required List<TileIdentity?> jokerAssignments,
  }) = _Meld;

  factory Meld.fromJson(Map<String, dynamic> json) => _$MeldFromJson(json);

  int get length => tiles.length;

  /// Resolved identity of every position: the joker assignment where there is
  /// one, the indicator's identity for a false joker, the printed identity
  /// otherwise.
  List<TileIdentity> identities(TileIdentity indicatorIdentity) {
    return List<TileIdentity>.generate(tiles.length, (i) {
      final assigned = jokerAssignments[i];
      if (assigned != null) return assigned;
      return tiles[i].printedIdentity ?? indicatorIdentity;
    });
  }

  /// Total face value of the meld, counting a wild as the tile it replaces.
  int pointValue(TileIdentity indicatorIdentity) {
    var total = 0;
    for (final identity in identities(indicatorIdentity)) {
      total += identity.number;
    }
    return total;
  }
}

/// A player's request to lay a meld. The engine resolves and validates it; the
/// UI never decides whether a meld is legal.
@freezed
abstract class MeldProposal with _$MeldProposal {
  const MeldProposal._();

  const factory MeldProposal({
    required MeldKind kind,

    /// Ordered tile ids. Order is what disambiguates a wild's identity.
    required List<int> tileIds,
  }) = _MeldProposal;

  factory MeldProposal.fromJson(Map<String, dynamic> json) =>
      _$MeldProposalFromJson(json);
}
