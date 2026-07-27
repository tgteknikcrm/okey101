import 'package:okey101/domain/engine/random_source.dart';
import 'package:okey101/domain/models/game_action.dart';
import 'package:okey101/domain/models/player_view.dart';

/// How hard a bot plays.
enum BotDifficulty { easy, medium, hard }

/// A bot decides one action at a time from a redacted [PlayerView].
///
/// Bots receive exactly what a human at the table could see and use the same
/// public engine API. A bot is never handed the full engine state, so hidden
/// information is unreachable at the type level rather than by discipline -
/// which is why the name of that type appears in no file under this directory.
///
/// Decisions must be deterministic given `(view, rng state)`.
abstract class BotBrain {
  BotDifficulty get difficulty;

  /// The next action for the seat whose turn it is.
  GameAction decide(PlayerView view, RandomSource rng);
}
