import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:okey101/domain/models/game_state.dart';

part 'saved_game.freezed.dart';
part 'saved_game.g.dart';

/// An in-progress match, exactly as it was left.
///
/// [rackSlots] is presentation state: it is stored so a restored game looks the
/// way the player left it, but it is deliberately NOT part of the replay log,
/// where it would be pure noise.
@freezed
abstract class SavedGame with _$SavedGame {
  const SavedGame._();

  const factory SavedGame({
    required GameState state,

    /// 26 entries, each a tile id or null for an empty slot.
    required List<int?> rackSlots,

    /// Milliseconds since epoch, supplied by the caller.
    required int savedAtMs,

    /// Bumped whenever the shape of this record changes so a stale save can be
    /// discarded instead of crashing the app.
    @Default(SavedGame.currentVersion) int version,
  }) = _SavedGame;

  factory SavedGame.fromJson(Map<String, dynamic> json) =>
      _$SavedGameFromJson(json);

  static const int currentVersion = 1;
}
