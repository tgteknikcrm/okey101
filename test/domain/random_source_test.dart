import 'package:flutter_test/flutter_test.dart';
import 'package:okey101/domain/engine/random_source.dart';

void main() {
  group('RandomSource (xorshift32)', () {
    test('is deterministic for a given seed', () {
      final a = RandomSource(12345);
      final b = RandomSource(12345);
      for (var i = 0; i < 1000; i++) {
        expect(a.nextUint32(), b.nextUint32());
      }
    });

    test('different seeds diverge', () {
      final a = RandomSource(1);
      final b = RandomSource(2);
      var same = 0;
      for (var i = 0; i < 200; i++) {
        if (a.nextUint32() == b.nextUint32()) same++;
      }
      expect(same, lessThan(5));
    });

    test('stays inside 32 bits, which is what keeps VM and JS identical', () {
      final rng = RandomSource(0xDEADBEEF);
      for (var i = 0; i < 5000; i++) {
        final value = rng.nextUint32();
        expect(value, greaterThanOrEqualTo(0));
        expect(value, lessThanOrEqualTo(0xFFFFFFFF));
        expect(rng.state, lessThanOrEqualTo(0xFFFFFFFF));
      }
    });

    test('a zero seed does not absorb the generator', () {
      final rng = RandomSource(0);
      final values = List.generate(50, (_) => rng.nextUint32());
      expect(values.toSet().length, greaterThan(40));
    });

    test('state can be saved and restored mid-sequence', () {
      final rng = RandomSource(777);
      for (var i = 0; i < 37; i++) {
        rng.nextUint32();
      }
      final saved = rng.state;
      final expected = List.generate(20, (_) => rng.nextUint32());

      final restored = RandomSource.fromState(saved);
      final actual = List.generate(20, (_) => restored.nextUint32());
      expect(actual, expected);
    });

    test('nextInt stays in range', () {
      final rng = RandomSource(99);
      for (final max in [1, 2, 4, 13, 21, 106]) {
        for (var i = 0; i < 500; i++) {
          final value = rng.nextInt(max);
          expect(value, greaterThanOrEqualTo(0));
          expect(value, lessThan(max));
        }
      }
    });

    test('nextInt rejects a non-positive bound', () {
      final rng = RandomSource(1);
      expect(() => rng.nextInt(0), throwsArgumentError);
      expect(() => rng.nextInt(-3), throwsArgumentError);
    });

    test('nextInt is roughly uniform over 4 buckets', () {
      final rng = RandomSource(4242);
      final counts = List<int>.filled(4, 0);
      const draws = 40000;
      for (var i = 0; i < draws; i++) {
        counts[rng.nextInt(4)]++;
      }
      for (final count in counts) {
        // +/-5% of the expected 10000.
        expect(count, inInclusiveRange(9500, 10500));
      }
    });

    test('shuffle is a permutation and is reproducible', () {
      final source = List<int>.generate(106, (i) => i);
      final a = RandomSource(2024).shuffled(source);
      final b = RandomSource(2024).shuffled(source);
      expect(a, b);
      expect(a.toSet(), source.toSet());
      expect(a, isNot(source));
      // The input list must not be touched.
      expect(source, List<int>.generate(106, (i) => i));
    });

    test('nextDouble stays in [0, 1)', () {
      final rng = RandomSource(31337);
      for (var i = 0; i < 2000; i++) {
        final value = rng.nextDouble();
        expect(value, greaterThanOrEqualTo(0.0));
        expect(value, lessThan(1.0));
      }
    });

    test('pick rejects an empty list', () {
      expect(() => RandomSource(1).pick<int>([]), throwsArgumentError);
    });
  });
}
