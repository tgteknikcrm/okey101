import 'package:okey101/domain/models/meld.dart';
import 'package:okey101/domain/models/rule_set.dart';
import 'package:okey101/domain/models/tile.dart';
import 'package:okey101/domain/rules/tile_semantics.dart';

/// One meld the solver picked, already resolved down to concrete tiles.
class SolvedMeld {
  const SolvedMeld({
    required this.kind,
    required this.tiles,
    required this.jokerAssignments,
    required this.points,
  });

  final MeldKind kind;
  final List<Tile> tiles;
  final List<TileIdentity?> jokerAssignments;

  /// Face value, counting a wild as the tile it replaces.
  final int points;

  MeldProposal toProposal() => MeldProposal(
        kind: kind,
        tileIds: tiles.map((t) => t.id).toList(),
      );
}

/// A partition of a hand into melds plus whatever is left over.
class MeldSolution {
  const MeldSolution({
    required this.melds,
    required this.leftovers,
    required this.points,
    required this.deadwood,
  });

  static const MeldSolution empty = MeldSolution(
    melds: <SolvedMeld>[],
    leftovers: <Tile>[],
    points: 0,
    deadwood: 0,
  );

  final List<SolvedMeld> melds;
  final List<Tile> leftovers;

  /// Total face value of the melds. This is what the 101 threshold measures.
  final int points;

  /// Total deadwood value of [leftovers].
  final int deadwood;

  bool get usesEveryTile => leftovers.isEmpty;

  List<MeldProposal> toProposals() =>
      melds.map((m) => m.toProposal()).toList();
}

enum _Objective {
  /// Maximise the face value laid down: "can I open with 101?"
  points,

  /// Maximise the deadwood removed from the rack, which is the same thing as
  /// minimising what is left. Differs from [points] because an okey left in
  /// hand costs 25 while it only ever scores its replaced face value.
  deadwood,

  /// Maximise the NUMBER of melded tiles regardless of value. This is what
  /// answers "can I go out?" exactly: a hand can finish when it can meld all
  /// but one of its tiles, and no value-based objective decides that reliably
  /// (leaving two cheap tiles out can beat leaving one expensive one).
  tileCount,
}

/// Partitions a multiset of tiles into the best set of melds.
///
/// The search takes the lowest remaining tile and either drops it into deadwood
/// or tries every meld that could contain it. Because tiles are indexed
/// colour-major, "lowest remaining" is always the first tile of its colour, so
/// any run containing it must start at it - which prunes the tree hard. Results
/// are memoised on a canonical count signature.
class MeldSolver {
  MeldSolver(this.semantics);

  final TileSemantics semantics;

  RuleSet get _rules => semantics.ruleSet;

  /// Highest-scoring partition. Answers "can I open with 101?".
  MeldSolution maximizePoints(List<Tile> tiles) =>
      _solve(tiles, _Objective.points);

  /// Partition leaving the lowest unmelded face value. Bots' hand evaluation.
  MeldSolution minimizeDeadwood(List<Tile> tiles) =>
      _solve(tiles, _Objective.deadwood);

  /// The partition that melds as many tiles as possible, ignoring value.
  MeldSolution maximizeMeldedTiles(List<Tile> tiles) =>
      _solve(tiles, _Objective.tileCount);

  /// True when every tile can be melded with nothing left over.
  bool canMeldEverything(List<Tile> tiles) {
    if (tiles.isEmpty) return true;
    return maximizeMeldedTiles(tiles).usesEveryTile;
  }

  /// True when the hand can go out: every tile melded except one to discard.
  ///
  /// Returns the tile that would be discarded, or null when it cannot be done.
  /// Normally one solve is enough - only the rare hand that melds completely
  /// needs the fallback scan for a tile it can afford to leave out.
  Tile? canFinish(List<Tile> tiles) {
    if (tiles.isEmpty) return null;
    final solution = maximizeMeldedTiles(tiles);
    if (solution.leftovers.length == 1) return solution.leftovers.single;
    if (solution.leftovers.isNotEmpty) return null;

    final tried = <int>{};
    for (final candidate in tiles) {
      final signature = semantics.isWild(candidate)
          ? -1
          : semantics.fixedIdentity(candidate).index;
      if (!tried.add(signature)) continue;
      final rest = List<Tile>.of(tiles)..remove(candidate);
      if (canMeldEverything(rest)) return candidate;
    }
    return null;
  }

  /// The most pairs ("cift") this hand can show at once.
  ///
  /// A pair is two tiles of the same colour AND number. The okey may complete a
  /// pair; two false jokers pair with each other because both carry the
  /// indicator's identity.
  List<SolvedMeld> bestPairs(List<Tile> tiles) {
    final pools = List<List<Tile>>.generate(52, (_) => <Tile>[]);
    final wilds = <Tile>[];
    for (final tile in tiles) {
      if (semantics.isWild(tile)) {
        wilds.add(tile);
      } else {
        pools[semantics.fixedIdentity(tile).index].add(tile);
      }
    }

    final pairs = <SolvedMeld>[];
    final singles = <Tile>[];
    for (var index = 0; index < 52; index++) {
      final pool = pools[index];
      final identity = TileIdentity.fromIndex(index);
      var i = 0;
      while (i + 1 < pool.length) {
        pairs.add(
          SolvedMeld(
            kind: MeldKind.pair,
            tiles: [pool[i], pool[i + 1]],
            jokerAssignments: const [null, null],
            points: identity.number * 2,
          ),
        );
        i += 2;
      }
      if (i < pool.length) singles.add(pool[i]);
    }

    // Each wild can complete one pair with a leftover single. Pairing two wilds
    // is not allowed - a meld may never be made of jokers only. Spend wilds on
    // the highest singles first so the remaining deadwood is smallest.
    singles.sort(
      (a, b) => semantics
          .fixedIdentity(b)
          .number
          .compareTo(semantics.fixedIdentity(a).number),
    );
    // A pair is two tiles, so at most one of them can ever be a wild, and a
    // rule set that bans jokers outright bans this pairing with them. The old
    // expression multiplied by maxJokersPerMeld, which at zero made the budget
    // singles.length and then indexed wilds past its end - reachable from the
    // Settings spinner, whose minimum is 0.
    // Written out rather than calling min: lib/domain is pure Dart and
    // purity_test bans the whole maths library by name, so that RandomSource
    // stays the only source of randomness in the game.
    final wildBudget = _rules.maxJokersPerMeld < 1
        ? 0
        : (wilds.length < singles.length ? wilds.length : singles.length);
    for (var i = 0; i < wildBudget; i++) {
      final identity = semantics.fixedIdentity(singles[i]);
      pairs.add(
        SolvedMeld(
          kind: MeldKind.pair,
          tiles: [singles[i], wilds[i]],
          jokerAssignments: [null, identity],
          points: identity.number * 2,
        ),
      );
    }
    return pairs;
  }

  MeldSolution _solve(List<Tile> tiles, _Objective objective) {
    if (tiles.isEmpty) return MeldSolution.empty;

    final pools = List<List<Tile>>.generate(52, (_) => <Tile>[]);
    final wilds = <Tile>[];
    for (final tile in tiles) {
      if (semantics.isWild(tile)) {
        wilds.add(tile);
      } else {
        pools[semantics.fixedIdentity(tile).index].add(tile);
      }
    }
    final counts = List<int>.generate(52, (i) => pools[i].length);

    final search = _Search(
      objective: objective,
      rules: _rules,
      okeyValue: _rules.okeyDeadwoodValue,
    );
    final node = search.run(counts, wilds.length);

    final melds = <SolvedMeld>[];
    for (final choice in node.melds) {
      final meldTiles = <Tile>[];
      final assignments = <TileIdentity?>[];
      var points = 0;
      for (var i = 0; i < choice.slots.length; i++) {
        final slot = choice.slots[i];
        if (slot < 0) {
          meldTiles.add(wilds.removeLast());
          assignments.add(choice.identities[i]);
        } else {
          meldTiles.add(pools[slot].removeLast());
          assignments.add(null);
        }
        points += choice.identities[i].number;
      }
      melds.add(
        SolvedMeld(
          kind: choice.kind,
          tiles: meldTiles,
          jokerAssignments: assignments,
          points: points,
        ),
      );
    }

    final leftovers = <Tile>[
      for (final pool in pools) ...pool,
      ...wilds,
    ];
    return MeldSolution(
      melds: melds,
      leftovers: leftovers,
      points: melds.fold(0, (sum, m) => sum + m.points),
      deadwood: semantics.deadwoodOf(leftovers),
    );
  }
}

class _Choice {
  const _Choice({
    required this.kind,
    required this.slots,
    required this.identities,
    required this.weight,
    required this.wildsUsed,
  });

  /// Identity index for a real tile, or -1 for a wild.
  final List<int> slots;
  final List<TileIdentity> identities;
  final MeldKind kind;
  final int weight;
  final int wildsUsed;
}

class _Node {
  const _Node(this.score, this.melds);

  final int score;
  final List<_Choice> melds;
}

class _Search {
  _Search({
    required this.objective,
    required this.rules,
    required this.okeyValue,
  });

  final _Objective objective;
  final RuleSet rules;
  final int okeyValue;

  final Map<String, _Node> _memo = <String, _Node>{};
  final List<int> _keyBuffer = List<int>.filled(53, 0);

  static const _Node _emptyNode = _Node(0, <_Choice>[]);

  _Node run(List<int> counts, int wilds) => _search(counts, wilds);

  /// What melding one ordinary tile of face value [number] is worth under the
  /// current objective.
  int _realWeight(int number) =>
      objective == _Objective.tileCount ? 1 : number;

  /// What melding a wild in a slot of face value [number] is worth.
  ///
  /// Under [_Objective.deadwood] it is the okey's rack value, because that is
  /// what placing it saves; under [_Objective.points] it only ever scores the
  /// tile it stands in for.
  int _wildWeight(int number) => switch (objective) {
        _Objective.points => number,
        _Objective.deadwood => okeyValue,
        _Objective.tileCount => 1,
      };

  String _key(List<int> counts, int wilds) {
    _keyBuffer.setRange(0, 52, counts);
    _keyBuffer[52] = wilds;
    return String.fromCharCodes(_keyBuffer);
  }

  _Node _search(List<int> counts, int wilds) {
    var pointer = 0;
    while (pointer < 52 && counts[pointer] == 0) {
      pointer++;
    }
    if (pointer == 52) return _emptyNode;

    final key = _key(counts, wilds);
    final cached = _memo[key];
    if (cached != null) return cached;

    // Leave the lowest remaining tile unmelded.
    counts[pointer]--;
    var best = _search(counts, wilds);
    counts[pointer]++;

    for (final choice in _candidates(counts, wilds, pointer)) {
      _apply(counts, choice, -1);
      final sub = _search(counts, wilds - choice.wildsUsed);
      _apply(counts, choice, 1);
      final total = choice.weight + sub.score;
      if (total > best.score) {
        best = _Node(total, <_Choice>[choice, ...sub.melds]);
      }
    }

    _memo[key] = best;
    return best;
  }

  void _apply(List<int> counts, _Choice choice, int sign) {
    for (final slot in choice.slots) {
      if (slot >= 0) counts[slot] += sign;
    }
  }

  List<_Choice> _candidates(List<int> counts, int wilds, int pointer) {
    final out = <_Choice>[];
    final color = TileColor.values[pointer ~/ 13];
    final number = (pointer % 13) + 1;
    final budget =
        wilds < rules.maxJokersPerMeld ? wilds : rules.maxJokersPerMeld;

    _addRuns(out, counts, budget, pointer, color, number);
    _addSets(out, counts, budget, pointer, color, number);
    return out;
  }

  /// Runs are never circular, so a run containing the lowest remaining tile of
  /// its colour must start at it and cannot pass 13.
  void _addRuns(
    List<_Choice> out,
    List<int> counts,
    int budget,
    int pointer,
    TileColor color,
    int number,
  ) {
    final maxLength = rules.maxRunLengthOnLayDown;
    for (var length = 3; length <= maxLength; length++) {
      if (number + length - 1 > 13) break;

      final mustBeWild = <int>[];
      final couldBeWild = <int>[];
      for (var offset = 1; offset < length; offset++) {
        if (counts[pointer + offset] == 0) {
          mustBeWild.add(offset);
        } else {
          couldBeWild.add(offset);
        }
      }
      if (mustBeWild.length > budget) continue;

      // A wild may also stand in for a tile that IS available, which can free
      // that real tile for another meld. Enumerate those substitutions too.
      final spare = budget - mustBeWild.length;
      for (final extra in _subsets(couldBeWild, spare)) {
        final wildOffsets = <int>{...mustBeWild, ...extra};
        if (wildOffsets.length == length) continue; // never all jokers
        out.add(
          _buildRun(pointer, color, number, length, wildOffsets),
        );
      }
    }
  }

  _Choice _buildRun(
    int pointer,
    TileColor color,
    int number,
    int length,
    Set<int> wildOffsets,
  ) {
    final slots = <int>[];
    final identities = <TileIdentity>[];
    var weight = 0;
    for (var offset = 0; offset < length; offset++) {
      final identity = TileIdentity(color: color, number: number + offset);
      identities.add(identity);
      if (wildOffsets.contains(offset)) {
        slots.add(-1);
        weight += _wildWeight(identity.number);
      } else {
        slots.add(pointer + offset);
        weight += _realWeight(identity.number);
      }
    }
    return _Choice(
      kind: MeldKind.run,
      slots: slots,
      identities: identities,
      weight: weight,
      wildsUsed: wildOffsets.length,
    );
  }

  void _addSets(
    List<_Choice> out,
    List<int> counts,
    int budget,
    int pointer,
    TileColor color,
    int number,
  ) {
    final otherColors = <TileColor>[
      for (final c in TileColor.values)
        if (c != color && counts[c.index * 13 + number - 1] > 0) c,
    ];
    final freeColors = <TileColor>[
      for (final c in TileColor.values)
        if (c != color) c,
    ];

    for (var size = 3; size <= 4; size++) {
      for (var wildCount = 0; wildCount <= budget; wildCount++) {
        final realOthers = size - 1 - wildCount;
        if (realOthers < 0 || realOthers > otherColors.length) continue;
        // The wilds have to stand in for colours the set does not already show.
        if (realOthers + wildCount + 1 > freeColors.length + 1) continue;

        for (final chosen in _colorSubsets(otherColors, realOthers)) {
          final used = <TileColor>{color, ...chosen};
          final remaining = freeColors.where((c) => !used.contains(c)).toList();
          if (remaining.length < wildCount) continue;

          final slots = <int>[pointer];
          final identities = <TileIdentity>[
            TileIdentity(color: color, number: number),
          ];
          var weight = _realWeight(number);
          for (final c in chosen) {
            slots.add(c.index * 13 + number - 1);
            identities.add(TileIdentity(color: c, number: number));
            weight += _realWeight(number);
          }
          for (var i = 0; i < wildCount; i++) {
            slots.add(-1);
            identities.add(
              TileIdentity(color: remaining[i], number: number),
            );
            weight += _wildWeight(number);
          }
          out.add(
            _Choice(
              kind: MeldKind.set,
              slots: slots,
              identities: identities,
              weight: weight,
              wildsUsed: wildCount,
            ),
          );
        }
      }
    }
  }

  /// All subsets of [items] with at most [maxSize] elements.
  static List<List<int>> _subsets(List<int> items, int maxSize) {
    final result = <List<int>>[<int>[]];
    if (maxSize <= 0 || items.isEmpty) return result;
    for (var i = 0; i < items.length; i++) {
      result.add(<int>[items[i]]);
      if (maxSize >= 2) {
        for (var j = i + 1; j < items.length; j++) {
          result.add(<int>[items[i], items[j]]);
        }
      }
    }
    return result;
  }

  /// All subsets of [colors] with exactly [size] elements. [colors] never holds
  /// more than three entries, so this stays trivial.
  static List<List<TileColor>> _colorSubsets(
    List<TileColor> colors,
    int size,
  ) {
    if (size == 0) return <List<TileColor>>[<TileColor>[]];
    if (size > colors.length) return const <List<TileColor>>[];
    final result = <List<TileColor>>[];
    void recurse(int start, List<TileColor> current) {
      if (current.length == size) {
        result.add(List<TileColor>.of(current));
        return;
      }
      for (var i = start; i < colors.length; i++) {
        current.add(colors[i]);
        recurse(i + 1, current);
        current.removeLast();
      }
    }

    recurse(0, <TileColor>[]);
    return result;
  }
}
