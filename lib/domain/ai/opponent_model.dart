import 'package:okey101/domain/ai/bot_utils.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/player_view.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// What one bot believes about one opponent.
///
/// Everything here is derived from public information only: the opponent's
/// open badge, their tile count, and their discard pile. A bot cannot see a
/// rack, so this is an estimate and nothing more.
class OpponentBelief {
  const OpponentBelief({
    required this.seat,
    required this.hasOpened,
    required this.openThreat,
    required this.turnsPlayed,
    required this.averageDiscardValue,
  });

  final int seat;
  final bool hasOpened;

  /// 0..1 estimate that this opponent opens soon (1 when they already have).
  final double openThreat;
  final int turnsPlayed;
  final double averageDiscardValue;
}

/// Reads the table and guesses where everyone else is.
abstract final class OpponentModel {
  static List<OpponentBelief> beliefs(PlayerView view) {
    final semantics = BotUtils.semanticsOf(view);
    return <OpponentBelief>[
      for (final opponent in view.opponents)
        _believe(view, opponent, semantics),
    ];
  }

  static OpponentBelief _believe(
    PlayerView view,
    OpponentView opponent,
    TileSemantics semantics,
  ) {
    final turns = opponent.discards.length;
    var total = 0;
    for (final tile in opponent.discards) {
      total += semantics.fixedIdentity(tile).number;
    }
    final average = turns == 0 ? 7.0 : total / turns;

    if (opponent.hasOpened) {
      return OpponentBelief(
        seat: opponent.seat,
        hasOpened: true,
        openThreat: 1,
        turnsPlayed: turns,
        averageDiscardValue: average,
      );
    }

    // Two weak but real signals:
    //  * time. There are only 20 draws in a hand, so every turn that passes
    //    without an open makes one less likely.
    //  * what they throw. Somebody shedding 11s, 12s and 13s is not holding a
    //    101-point lay-down; somebody throwing 1s and 2s may well be.
    final timePressure = (turns / 6.0).clamp(0.0, 1.0);
    final lowDiscards = ((8.0 - average) / 6.0).clamp(0.0, 1.0);
    final threat = (0.25 + 0.45 * lowDiscards + 0.30 * timePressure * lowDiscards)
        .clamp(0.0, 0.95);

    return OpponentBelief(
      seat: opponent.seat,
      hasOpened: false,
      openThreat: threat,
      turnsPlayed: turns,
      averageDiscardValue: average,
    );
  }

  /// How dangerous it is to hand [tile] to the seat on the right - the only
  /// player who can pick this bot's discards up.
  ///
  /// Returns roughly 0 (safe) to 40 (hands them a meld).
  static double dangerToRightNeighbour(PlayerView view, Tile tile) {
    final semantics = BotUtils.semanticsOf(view);
    final right = view.rightNeighbour;
    if (semantics.isWild(tile)) {
      // The okey is the single most useful tile at the table.
      return 40;
    }
    final identity = semantics.fixedIdentity(tile);
    var danger = identity.number * 0.35;

    // A tile that extends one of their melds is a gift, and they can work it
    // the moment they pick it up.
    for (final meld in view.table) {
      if (meld.ownerSeat != right.seat) continue;
      final identities = meld.identities(semantics.indicatorIdentity);
      if (meld.kind == MeldKind.run) {
        final color = identities.first.color;
        if (identity.color != color) continue;
        if (identity.number == identities.first.number - 1 ||
            identity.number == identities.last.number + 1) {
          danger += 25;
        }
      } else if (meld.kind == MeldKind.set && meld.tiles.length < 4) {
        if (identity.number == identities.first.number &&
            !identities.map((i) => i.color).contains(identity.color)) {
          danger += 25;
        }
      }
    }

    // A tile they have already thrown away is obviously safe for them.
    for (final discarded in right.discards) {
      if (semantics.fixedIdentity(discarded) == identity) {
        danger -= 12;
        break;
      }
    }

    // Once they have opened, everything they can work is dangerous.
    if (right.hasOpened) danger *= 1.4;

    return danger < 0 ? 0 : danger;
  }
}
