// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Disaster AIDvisor';

  @override
  String get tagline => 'Have questions? Start here.';

  @override
  String greetingMorningNamed(String name) {
    return 'Good morning, $name. How may I help today?';
  }

  @override
  String greetingAfternoonNamed(String name) {
    return 'Good afternoon, $name. How may I help today?';
  }

  @override
  String greetingEveningNamed(String name) {
    return 'Good evening, $name. How may I help today?';
  }

  @override
  String get greetingMorningAnon =>
      'Good morning. I\'m your Disaster AIDvisor. How may I help today?';

  @override
  String get greetingAfternoonAnon =>
      'Good afternoon. I\'m your Disaster AIDvisor. How may I help today?';

  @override
  String get greetingEveningAnon =>
      'Good evening. I\'m your Disaster AIDvisor. How may I help today?';

  @override
  String get briefingLabel => 'TODAY\'S BRIEFING';

  @override
  String briefingLoading(String date, String area) {
    return '$date  ·  Checking current conditions for $area…';
  }

  @override
  String briefingUnavailable(String date) {
    return '$date  ·  Live conditions unavailable. Always verify with local authorities during active events.';
  }

  @override
  String briefingNoAlerts(String date, String area) {
    return '$date  ·  No active NWS alerts for $area.';
  }

  @override
  String briefingAlertsSummary(String date, String summary, String area) {
    return '$date  ·  $summary in effect for $area. Follow local official guidance.';
  }

  @override
  String briefingAreaZip(String zip) {
    return 'ZIP $zip';
  }

  @override
  String get briefingAreaGeneric => 'your area';

  @override
  String get topicPrepareTitle => 'Preparing for Hurricane Season';

  @override
  String get topicPrepareSubtitle => 'Plans, supplies, and priorities';

  @override
  String get topicPreparePrompt =>
      'Walk me through preparing for hurricane season.';

  @override
  String get topicRespondTitle => 'Response During an Event';

  @override
  String get topicRespondSubtitle => 'What to do as conditions develop';

  @override
  String get topicRespondPrompt =>
      'A major storm is heading my way. What should I do right now?';

  @override
  String get topicRecoverTitle => 'After an Incident';

  @override
  String get topicRecoverSubtitle => 'Recovery, claims, and next steps';

  @override
  String get topicRecoverPrompt =>
      'My home was damaged. How do I start recovering and filing claims?';

  @override
  String get chatInputPlaceholder => 'Type a message…';

  @override
  String get chatErrorGeneric =>
      'Error: Unable to get response. Please try again later.';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get noConversationToShare => 'No conversation to share yet.';

  @override
  String shareSubject(String date) {
    return 'Disaster AIDvisor Conversation — $date';
  }

  @override
  String shareHeader(String date) {
    return 'Disaster AIDvisor Conversation — $date';
  }

  @override
  String get shareSpeakerYou => 'You';

  @override
  String get shareSpeakerBot => 'AIDvisor';

  @override
  String get menuShareConversation => 'Share Conversation';

  @override
  String get menuClearChat => 'Clear Chat';

  @override
  String get menuReportIssue => 'Report an Issue';

  @override
  String get menuLogout => 'Logout';

  @override
  String get menuDeleteAccount => 'Delete Account';

  @override
  String get menuTermsConditions => 'Terms & Conditions';

  @override
  String get menuLanguage => 'Language';

  @override
  String get homeTooltip => 'Return to home';

  @override
  String get clearChatTitle => 'Clear Chat';

  @override
  String get clearChatBody =>
      'This will permanently delete your entire conversation history. Continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get inputDisclaimer =>
      'Disaster AIDvisor is for general informational purposes only and is not a substitute for emergency services — if you are in immediate danger, please call 911.';
}
