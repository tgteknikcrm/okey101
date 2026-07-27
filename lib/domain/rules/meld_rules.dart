import 'package:okey101/domain/models/game_error.dart';
import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// Outcome of validating a proposed meld.
sealed class MeldCheck {
  const MeldCheck();
}

final class MeldValid extends MeldCheck {
  const MeldValid({required this.jokerAssignments, required this.points});

  /// Index-parallel with the proposed tiles; non-null only where a wild sits.
  final List<TileIdentity?> jokerAssignments;

  /// Face-value total, counting a wild as the tile it replaces.
  final int points;
}

final class MeldRejected extends MeldCheck {
  const MeldRejected(this.error);

  final GameError error;
}

/// Outcome of extending or repairing a meld already on the table.
sealed class MeldMutation {
  const MeldMutation();
}

final class MeldMutated extends MeldMutation {
  const MeldMutated(this.meld);

  final Meld meld;
}

final class MeldMutationRejected extends MeldMutation {
  const MeldMutationRejected(this.error);

  final GameError error;
}

/// All meld legality lives here. Widgets never decide whether a meld is valid;
/// they ask this.
abstract final class MeldRules {
  /// Validates a proposed meld.
  ///
  /// [isLayDown] applies the maximum-run-length limit, which by rule constrains
  /// only melds laid on the table, not table runs extended later.
  static MeldCheck validate({
    required MeldKind kind,
    required List<Tile> tiles,
    required TileSemantics semantics,
    required bool isLayDown,
  }) {
    if (tiles.isEmpty) {
      return const MeldRejected(GameError.emptyProposal());
    }
    final rules = semantics.ruleSet;
    var wildCount = 0;
    for (final tile in tiles) {
      if (semantics.isWild(tile)) wildCount++;
    }
    if (wildCount > rules.maxJokersPerMeld) {
      return MeldRejected(
        GameError.tooManyJokers(
          count: wildCount,
          max: rules.maxJokersPerMeld,
        ),
      );
    }
    if (wildCount == tiles.length) {
      return const MeldRejected(GameError.meldAllJokers());
    }
    return switch (kind) {
      MeldKind.run => _validateRun(tiles, semantics, isLayDown: isLayDown),
      MeldKind.set => _validateSet(tiles, semantics),
      MeldKind.pair => _validatePair(tiles, semantics),
    };
  }

  static MeldCheck _validateRun(
    List<Tile> tiles,
    TileSemantics semantics, {
    required bool isLayDown,
  }) {
    final rules = semantics.ruleSet;
    if (tiles.length < 3) {
      return MeldRejected(GameError.runTooShort(length: tiles.length));
    }
    if (isLayDown && tiles.length > rules.maxRunLengthOnLayDown) {
      return MeldRejected(
        GameError.runTooLongOnLayDown(
          length: tiles.length,
          max: rules.maxRunLengthOnLayDown,
        ),
      );
    }

    var anchorIndex = -1;
    TileColor? baseColor;
    for (var i = 0; i < tiles.length; i++) {
      if (semantics.isWild(tiles[i])) continue;
      final identity = semantics.fixedIdentity(tiles[i]);
      if (baseColor == null) {
        baseColor = identity.color;
        anchorIndex = i;
      } else if (identity.color != baseColor) {
        return const MeldRejected(GameError.runColorMismatch());
      }
    }
    // wildCount == tiles.length was rejected by the caller, so a base colour
    // always exists here.
    final color = baseColor!;
    final anchorNumber = semantics.fixedIdentity(tiles[anchorIndex]).number;

    // Linear reading first. This is the only reading the default rules accept.
    final linear = List<int>.generate(
      tiles.length,
      (p) => anchorNumber + (p - anchorIndex),
    );
    var linearOk = linear.first >= 1 && linear.last <= 13;
    if (linearOk) {
      for (var i = 0; i < tiles.length; i++) {
        if (semantics.isWild(tiles[i])) continue;
        if (semantics.fixedIdentity(tiles[i]).number != linear[i]) {
          linearOk = false;
          break;
        }
      }
    }
    if (linearOk) {
      return _runResult(tiles, semantics, color, linear);
    }

    // The tiles are not a linear run. If they WOULD be a run under mod-13, the
    // player tried something like 12-13-1, and deserves the specific message.
    final wrapped = List<int>.generate(
      tiles.length,
      (p) => ((anchorNumber - 1 + (p - anchorIndex)) % 13) + 1,
    );
    var wrapOk = true;
    for (var i = 0; i < tiles.length; i++) {
      if (semantics.isWild(tiles[i])) continue;
      if (semantics.fixedIdentity(tiles[i]).number != wrapped[i]) {
        wrapOk = false;
        break;
      }
    }
    if (!wrapOk) {
      return const MeldRejected(GameError.runNotConsecutive());
    }
    if (!rules.allowCircularRuns) {
      return const MeldRejected(GameError.runCannotWrap());
    }
    return _runResult(tiles, semantics, color, wrapped);
  }

  static MeldCheck _runResult(
    List<Tile> tiles,
    TileSemantics semantics,
    TileColor color,
    List<int> numbers,
  ) {
    final assignments = List<TileIdentity?>.filled(tiles.length, null);
    var points = 0;
    for (var i = 0; i < tiles.length; i++) {
      if (semantics.isWild(tiles[i])) {
        assignments[i] = TileIdentity(color: color, number: numbers[i]);
      }
      points += numbers[i];
    }
    return MeldValid(jokerAssignments: assignments, points: points);
  }

  static MeldCheck _validateSet(List<Tile> tiles, TileSemantics semantics) {
    if (tiles.length < 3 || tiles.length > 4) {
      return MeldRejected(GameError.setWrongSize(size: tiles.length));
    }
    int? number;
    final usedColors = <TileColor>{};
    for (final tile in tiles) {
      if (semantics.isWild(tile)) continue;
      final identity = semantics.fixedIdentity(tile);
      if (number == null) {
        number = identity.number;
      } else if (identity.number != number) {
        return const MeldRejected(GameError.setNumberMismatch());
      }
      if (!usedColors.add(identity.color)) {
        return MeldRejected(GameError.setDuplicateColor(color: identity.color));
      }
    }
    // number is non-null: a set made only of wilds was rejected by the caller.
    final setNumber = number!;
    final assignments = List<TileIdentity?>.filled(tiles.length, null);
    final free = TileColor.values.where((c) => !usedColors.contains(c)).toList();
    var freeIndex = 0;
    for (var i = 0; i < tiles.length; i++) {
      if (!semantics.isWild(tiles[i])) continue;
      if (freeIndex >= free.length) {
        // More wilds than free colours; only reachable with a very permissive
        // maxJokersPerMeld, but it is still an illegal set.
        return const MeldRejected(GameError.setNumberMismatch());
      }
      assignments[i] = TileIdentity(color: free[freeIndex], number: setNumber);
      freeIndex++;
    }
    return MeldValid(
      jokerAssignments: assignments,
      points: setNumber * tiles.length,
    );
  }

  static MeldCheck _validatePair(List<Tile> tiles, TileSemantics semantics) {
    if (tiles.length != 2) {
      return const MeldRejected(GameError.invalidPair());
    }
    final firstWild = semantics.isWild(tiles[0]);
    final secondWild = semantics.isWild(tiles[1]);
    if (firstWild && secondWild) {
      return const MeldRejected(GameError.meldAllJokers());
    }
    if (firstWild || secondWild) {
      final real = firstWild ? tiles[1] : tiles[0];
      final identity = semantics.fixedIdentity(real);
      final assignments = <TileIdentity?>[
        if (firstWild) identity else null,
        if (secondWild) identity else null,
      ];
      return MeldValid(
        jokerAssignments: assignments,
        points: identity.number * 2,
      );
    }
    // Two false jokers both carry the indicator's identity, so they pair with
    // each other and fall out of this comparison naturally.
    final a = semantics.fixedIdentity(tiles[0]);
    final b = semantics.fixedIdentity(tiles[1]);
    if (a.color != b.color || a.number != b.number) {
      return const MeldRejected(GameError.invalidPair());
    }
    return MeldValid(
      jokerAssignments: const <TileIdentity?>[null, null],
      points: a.number * 2,
    );
  }

  /// "Islemek": add [tile] to a meld already on the table.
  ///
  /// The maximum-run-length limit is deliberately NOT applied here - by rule it
  /// constrains only lay-down.
  static MeldMutation extend({
    required Meld meld,
    required Tile tile,
    required bool atStart,
    required TileSemantics semantics,
  }) {
    final rules = semantics.ruleSet;
    final incomingIsWild = semantics.isWild(tile);
    if (incomingIsWild) {
      final existingWilds =
          meld.jokerAssignments.where((a) => a != null).length;
      if (existingWilds + 1 > rules.maxJokersPerMeld) {
        return MeldMutationRejected(
          GameError.tooManyJokers(
            count: existingWilds + 1,
            max: rules.maxJokersPerMeld,
          ),
        );
      }
    }
    final identities = meld.identities(semantics.indicatorIdentity);
    switch (meld.kind) {
      case MeldKind.pair:
        return MeldMutationRejected(
          GameError.tileDoesNotExtendMeld(meldId: meld.id, tileId: tile.id),
        );
      case MeldKind.run:
        final color = identities.first.color;
        final rawTarget = atStart
            ? identities.first.number - 1
            : identities.last.number + 1;
        if (rawTarget < 1 || rawTarget > 13) {
          if (!rules.allowCircularRuns) {
            return const MeldMutationRejected(GameError.runCannotWrap());
          }
        }
        final target = ((rawTarget - 1) % 13) + 1;
        final wanted = TileIdentity(color: color, number: target);
        if (!incomingIsWild && semantics.fixedIdentity(tile) != wanted) {
          return MeldMutationRejected(
            GameError.tileDoesNotExtendMeld(meldId: meld.id, tileId: tile.id),
          );
        }
        final tiles = List<Tile>.of(meld.tiles);
        final assignments = List<TileIdentity?>.of(meld.jokerAssignments);
        if (atStart) {
          tiles.insert(0, tile);
          assignments.insert(0, incomingIsWild ? wanted : null);
        } else {
          tiles.add(tile);
          assignments.add(incomingIsWild ? wanted : null);
        }
        return MeldMutated(
          meld.copyWith(tiles: tiles, jokerAssignments: assignments),
        );
      case MeldKind.set:
        if (meld.tiles.length >= 4) {
          return MeldMutationRejected(
            GameError.setWrongSize(size: meld.tiles.length + 1),
          );
        }
        final number = identities.first.number;
        final used = identities.map((i) => i.color).toSet();
        final free =
            TileColor.values.where((c) => !used.contains(c)).toList();
        if (free.isEmpty) {
          return MeldMutationRejected(
            GameError.setWrongSize(size: meld.tiles.length + 1),
          );
        }
        TileIdentity wanted;
        if (incomingIsWild) {
          wanted = TileIdentity(color: free.first, number: number);
        } else {
          final identity = semantics.fixedIdentity(tile);
          if (identity.number != number) {
            return MeldMutationRejected(
              GameError.tileDoesNotExtendMeld(meldId: meld.id, tileId: tile.id),
            );
          }
          if (used.contains(identity.color)) {
            return MeldMutationRejected(
              GameError.setDuplicateColor(color: identity.color),
            );
          }
          wanted = identity;
        }
        return MeldMutated(
          meld.copyWith(
            tiles: [...meld.tiles, tile],
            jokerAssignments: [
              ...meld.jokerAssignments,
              if (incomingIsWild) wanted else null,
            ],
          ),
        );
    }
  }

  /// Swap the real tile in for a wild okey standing at [index] on the table.
  ///
  /// Returns the mutated meld; the caller is responsible for moving the freed
  /// okey into the player's hand. A false joker is not wild and can never be
  /// swapped this way.
  static MeldMutation replaceJoker({
    required Meld meld,
    required int index,
    required Tile tile,
    required TileSemantics semantics,
  }) {
    if (!semantics.ruleSet.canReplaceJokerOnTable) {
      return const MeldMutationRejected(GameError.jokerReplacementDisabled());
    }
    if (index < 0 || index >= meld.tiles.length) {
      return MeldMutationRejected(
        GameError.notAJokerAtPosition(meldId: meld.id, index: index),
      );
    }
    final standing = meld.tiles[index];
    if (standing.isFalseJoker) {
      return const MeldMutationRejected(GameError.cannotReplaceFalseJoker());
    }
    if (!semantics.isWild(standing)) {
      return MeldMutationRejected(
        GameError.notAJokerAtPosition(meldId: meld.id, index: index),
      );
    }
    if (semantics.isWild(tile)) {
      return const MeldMutationRejected(GameError.jokerReplacementMismatch());
    }
    final assigned = meld.jokerAssignments[index];
    if (assigned == null) {
      return MeldMutationRejected(
        GameError.notAJokerAtPosition(meldId: meld.id, index: index),
      );
    }
    final incoming = semantics.fixedIdentity(tile);
    if (meld.kind == MeldKind.set) {
      // In a set the joker stands for "this number in some colour the set does
      // not already show", so any legal missing colour is accepted.
      if (incoming.number != assigned.number) {
        return const MeldMutationRejected(GameError.jokerReplacementMismatch());
      }
      final identities = meld.identities(semantics.indicatorIdentity);
      for (var i = 0; i < identities.length; i++) {
        if (i == index) continue;
        if (identities[i].color == incoming.color) {
          return MeldMutationRejected(
            GameError.setDuplicateColor(color: incoming.color),
          );
        }
      }
    } else if (incoming != assigned) {
      return const MeldMutationRejected(GameError.jokerReplacementMismatch());
    }
    final tiles = List<Tile>.of(meld.tiles);
    final assignments = List<TileIdentity?>.of(meld.jokerAssignments);
    tiles[index] = tile;
    assignments[index] = null;
    return MeldMutated(
      meld.copyWith(tiles: tiles, jokerAssignments: assignments),
    );
  }
}
