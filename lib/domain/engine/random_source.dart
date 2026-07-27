/// A hand-written xorshift32 pseudo random generator.
///
/// The SDK's own `Random` class is deliberately not used anywhere that affects
/// game state: its seeded sequence is not guaranteed stable across Dart SDK
/// versions, and its 64-bit arithmetic behaves differently once compiled to
/// JavaScript. This project ships to the browser, so both are real bugs rather
/// than theoretical ones. (The purity test greps for the library name, so it is
/// spelled out nowhere in this file.)
///
/// The whole generator state is a single 32-bit int, which makes save/restore
/// and replay trivial: `(seed, canonicalActions)` fully determines a game.
class RandomSource {
  /// Creates a generator from [seed]. A zero seed is replaced by the golden
  /// ratio constant because xorshift32 is absorbing at zero.
  RandomSource(int seed) : _state = _sanitize(seed);

  /// Restores a generator that was previously serialised via [state].
  RandomSource.fromState(int state) : _state = _sanitize(state);

  int _state;

  static int _sanitize(int seed) {
    final masked = seed & 0xFFFFFFFF;
    return masked == 0 ? 0x9E3779B9 : masked;
  }

  /// The current 32-bit state. Persist this to resume an identical sequence.
  int get state => _state;

  /// Advances the generator and returns the next 32-bit value in `1..2^32-1`.
  ///
  /// Every shift result is masked back to 32 bits so the arithmetic is
  /// identical on the Dart VM and in compiled JavaScript.
  int nextUint32() {
    var x = _state;
    x ^= (x << 13) & 0xFFFFFFFF;
    x ^= x >> 17;
    x ^= (x << 5) & 0xFFFFFFFF;
    _state = x & 0xFFFFFFFF;
    return _state;
  }

  /// Returns a value in `0..max-1`.
  ///
  /// Uses rejection sampling so the distribution stays uniform; the naive
  /// modulo would bias low values whenever [max] does not divide 2^32.
  int nextInt(int max) {
    if (max <= 0) {
      throw ArgumentError.value(max, 'max', 'must be positive');
    }
    if (max == 1) return 0;
    final limit = 0x100000000 - (0x100000000 % max);
    var candidate = nextUint32();
    while (candidate >= limit) {
      candidate = nextUint32();
    }
    return candidate % max;
  }

  /// Returns a double in `[0, 1)`.
  double nextDouble() => nextUint32() / 0x100000000;

  /// Returns true with probability [probability].
  bool nextBool([double probability = 0.5]) => nextDouble() < probability;

  /// Fisher-Yates shuffle, in place.
  void shuffle<T>(List<T> list) {
    for (var i = list.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
  }

  /// Returns a shuffled copy, leaving [list] untouched.
  List<T> shuffled<T>(List<T> list) {
    final copy = List<T>.of(list);
    shuffle(copy);
    return copy;
  }

  /// Picks one element uniformly. Throws if [list] is empty.
  T pick<T>(List<T> list) {
    if (list.isEmpty) {
      throw ArgumentError.value(list, 'list', 'must not be empty');
    }
    return list[nextInt(list.length)];
  }
}
