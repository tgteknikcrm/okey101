import 'package:flutter/foundation.dart';

/// What the player is carrying: gold and diamonds.
///
/// Two plain integers, so no code generation and no JSON blob - they go into
/// their own preference keys. Hand-written rather than freezed because there is
/// nothing here for a union or a deep copy to do.
@immutable
class Wallet {
  const Wallet({this.gold = startingGold, this.diamonds = startingDiamonds});

  /// What a new player starts with.
  static const int startingGold = 5000;
  static const int startingDiamonds = 10;

  /// What one top-up hands over. There are no purchases in this game, so it is
  /// simply given.
  static const int topUpAmount = 5000;

  final int gold;
  final int diamonds;

  Wallet copyWith({int? gold, int? diamonds}) => Wallet(
        gold: gold ?? this.gold,
        diamonds: diamonds ?? this.diamonds,
      );

  @override
  bool operator ==(Object other) =>
      other is Wallet && other.gold == gold && other.diamonds == diamonds;

  @override
  int get hashCode => Object.hash(gold, diamonds);

  @override
  String toString() => 'Wallet(gold: $gold, diamonds: $diamonds)';
}
