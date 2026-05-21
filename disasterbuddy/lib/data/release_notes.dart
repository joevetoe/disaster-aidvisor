// What's New release notes.
// To ship a new release: bump kCurrentVersion AND pubspec.yaml's `version:`,
// then prepend a new entry to `releaseNotes`. The version string here must
// match the marketing version in pubspec exactly (the part before the +N
// build number).

class ReleaseNote {
  final String version;
  final String title;
  final String date; // ISO date, e.g. "2026-04-28"
  final List<String> highlights;

  const ReleaseNote({
    required this.version,
    required this.title,
    required this.date,
    required this.highlights,
  });
}

const String kCurrentVersion = '1.1.2';

const List<ReleaseNote> releaseNotes = [
  ReleaseNote(
    version: '1.1.2',
    title: "What's New",
    date: '2026-05-18',
    highlights: [
      'Updated sign-up to match the BuildSOS family — same fields across all BuildSOS apps.',
      'Smarter assistant powered by Claude — sharper, more conversational replies.',
      'Now available in English and Spanish — switch from the menu anytime.',
      'Refreshed home screen with all three topic prompts visible at a glance.',
      'New chat send button and message bubbles with the BuildSOS accent.',
      'Typing indicator while the assistant is preparing a reply.',
      'Long replies now anchor to the top so you don’t lose your place.',
    ],
  ),
  ReleaseNote(
    version: '1.1.0',
    title: "What's New",
    date: '2026-04-28',
    highlights: [
      'Smarter assistant powered by Claude — sharper, more conversational replies.',
      'Now available in English and Spanish — switch from the menu anytime.',
      'Refreshed home screen with all three topic prompts visible at a glance.',
      'New chat send button and message bubbles with the BuildSOS accent.',
      'Typing indicator while the assistant is preparing a reply.',
      'Long replies now anchor to the top so you don’t lose your place.',
      'Updated splash screen.',
    ],
  ),
];

ReleaseNote? get latestReleaseNote {
  for (final note in releaseNotes) {
    if (note.version == kCurrentVersion) return note;
  }
  return releaseNotes.isNotEmpty ? releaseNotes.first : null;
}
