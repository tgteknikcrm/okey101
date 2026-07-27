import 'package:okey101/domain/models/game_error.dart';
import 'package:okey101/domain/models/game_state.dart';

/// The result of applying a `GameAction`.
///
/// Illegal actions come back as [EngineErr] carrying a typed [GameError]. The
/// engine never throws and never silently no-ops.
sealed class EngineResult {
  const EngineResult();

  /// The new state, or null when the action was rejected.
  GameState? get stateOrNull => switch (this) {
        EngineOk(:final state) => state,
        EngineErr() => null,
      };

  /// The rejection reason, or null when the action was applied.
  GameError? get errorOrNull => switch (this) {
        EngineOk() => null,
        EngineErr(:final error) => error,
      };

  bool get isOk => this is EngineOk;
  bool get isErr => this is EngineErr;
}

final class EngineOk extends EngineResult {
  const EngineOk(this.state);

  final GameState state;
}

final class EngineErr extends EngineResult {
  const EngineErr(this.error);

  final GameError error;
}
