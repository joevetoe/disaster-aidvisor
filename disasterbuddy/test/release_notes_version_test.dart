import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:disasterbuddy/data/release_notes.dart';

String _pubspecMarketingVersion() {
  final file = File('pubspec.yaml');
  for (final line in file.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.startsWith('version:')) {
      final value = trimmed.substring('version:'.length).trim();
      return value.split('+').first;
    }
  }
  fail('No version: line found in pubspec.yaml');
}

void main() {
  test('kCurrentVersion matches pubspec.yaml version', () {
    expect(kCurrentVersion, _pubspecMarketingVersion());
  });

  test('latestReleaseNote exists for kCurrentVersion', () {
    final note = latestReleaseNote;
    expect(note, isNotNull);
    expect(note!.version, kCurrentVersion);
  });
}
