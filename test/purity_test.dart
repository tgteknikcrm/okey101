import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `lib/domain/` is pure Dart. This is enforced by test, not by convention.
///
/// A broken path must never make this pass silently, which is why the file
/// count is asserted as well.
void main() {
  const bannedPatterns = <String, String>{
    'package:flutter': 'package:flutter',
    'dart:ui': 'dart:ui',
    'dart:io': 'dart:io',
    'dart:html': 'dart:html',
    'package:web': 'package:web',
    'dart:js': 'dart:js',
    'dart:isolate': 'dart:isolate',
    'dart:ffi': 'dart:ffi',
    'dart:math': 'dart:math',
    'DateTime.now()': r'DateTime\s*\.\s*now\s*\(',
    'Random()': r'\bRandom\s*\(',
    'Stopwatch': r'\bStopwatch\s*\(',
  };

  late List<File> allDartFiles;
  late List<File> sourceFiles;

  setUpAll(() {
    final domain = Directory('lib/domain');
    expect(
      domain.existsSync(),
      isTrue,
      reason: 'lib/domain must exist - a wrong path would make this test vacuous',
    );
    allDartFiles = domain
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();
    sourceFiles = allDartFiles
        .where(
          (f) =>
              !f.path.endsWith('.freezed.dart') && !f.path.endsWith('.g.dart'),
        )
        .toList();
  });

  test('finds a plausible number of domain source files', () {
    expect(
      sourceFiles.length,
      greaterThanOrEqualTo(15),
      reason: 'Expected at least 15 hand-written files under lib/domain; '
          'found ${sourceFiles.length}. A broken path must not make the '
          'purity check pass silently.',
    );
  });

  test('no domain file reaches for Flutter, the platform, or ambient state',
      () {
    final violations = <String>[];
    for (final file in allDartFiles) {
      final source = file.readAsStringSync();
      for (final entry in bannedPatterns.entries) {
        if (RegExp(entry.value).hasMatch(source)) {
          violations.add('${file.path} contains banned "${entry.key}"');
        }
      }
    }
    expect(
      violations,
      isEmpty,
      reason: 'lib/domain must be pure Dart:\n${violations.join('\n')}',
    );
  });

  test('generated domain files exist for every model that declares a part', () {
    final missing = <String>[];
    for (final file in sourceFiles) {
      final source = file.readAsStringSync();
      for (final match
          in RegExp(r"""part\s+'([^']+\.(?:freezed|g)\.dart)'""")
              .allMatches(source)) {
        final partName = match.group(1)!;
        final partPath =
            '${file.parent.path}${Platform.pathSeparator}$partName';
        if (!File(partPath).existsSync()) {
          missing.add(partPath);
        }
      }
    }
    expect(missing, isEmpty, reason: 'Missing generated files:\n$missing');
  });
}
