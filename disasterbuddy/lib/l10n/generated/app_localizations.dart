import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Disaster AIDvisor'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Prepare · Respond · Recover'**
  String get tagline;

  /// No description provided for @greetingMorningNamed.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}. How may I help today?'**
  String greetingMorningNamed(String name);

  /// No description provided for @greetingAfternoonNamed.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}. How may I help today?'**
  String greetingAfternoonNamed(String name);

  /// No description provided for @greetingEveningNamed.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}. How may I help today?'**
  String greetingEveningNamed(String name);

  /// No description provided for @greetingMorningAnon.
  ///
  /// In en, this message translates to:
  /// **'Good morning. I\'m your Disaster AIDvisor. How may I help today?'**
  String get greetingMorningAnon;

  /// No description provided for @greetingAfternoonAnon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon. I\'m your Disaster AIDvisor. How may I help today?'**
  String get greetingAfternoonAnon;

  /// No description provided for @greetingEveningAnon.
  ///
  /// In en, this message translates to:
  /// **'Good evening. I\'m your Disaster AIDvisor. How may I help today?'**
  String get greetingEveningAnon;

  /// No description provided for @briefingLabel.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S BRIEFING'**
  String get briefingLabel;

  /// No description provided for @briefingLoading.
  ///
  /// In en, this message translates to:
  /// **'{date}  ·  Checking current conditions for {area}…'**
  String briefingLoading(String date, String area);

  /// No description provided for @briefingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'{date}  ·  Live conditions unavailable. Always verify with local authorities during active events.'**
  String briefingUnavailable(String date);

  /// No description provided for @briefingNoAlerts.
  ///
  /// In en, this message translates to:
  /// **'{date}  ·  No active NWS alerts for {area}.'**
  String briefingNoAlerts(String date, String area);

  /// No description provided for @briefingAlertsSummary.
  ///
  /// In en, this message translates to:
  /// **'{date}  ·  {summary} in effect for {area}. Follow local official guidance.'**
  String briefingAlertsSummary(String date, String summary, String area);

  /// No description provided for @briefingAreaZip.
  ///
  /// In en, this message translates to:
  /// **'ZIP {zip}'**
  String briefingAreaZip(String zip);

  /// No description provided for @briefingAreaGeneric.
  ///
  /// In en, this message translates to:
  /// **'your area'**
  String get briefingAreaGeneric;

  /// No description provided for @topicPrepareTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparing for Hurricane Season'**
  String get topicPrepareTitle;

  /// No description provided for @topicPrepareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plans, supplies, and priorities'**
  String get topicPrepareSubtitle;

  /// No description provided for @topicPreparePrompt.
  ///
  /// In en, this message translates to:
  /// **'Walk me through preparing for hurricane season.'**
  String get topicPreparePrompt;

  /// No description provided for @topicRespondTitle.
  ///
  /// In en, this message translates to:
  /// **'Response During an Event'**
  String get topicRespondTitle;

  /// No description provided for @topicRespondSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What to do as conditions develop'**
  String get topicRespondSubtitle;

  /// No description provided for @topicRespondPrompt.
  ///
  /// In en, this message translates to:
  /// **'A major storm is heading my way. What should I do right now?'**
  String get topicRespondPrompt;

  /// No description provided for @topicRecoverTitle.
  ///
  /// In en, this message translates to:
  /// **'After an Incident'**
  String get topicRecoverTitle;

  /// No description provided for @topicRecoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery, claims, and next steps'**
  String get topicRecoverSubtitle;

  /// No description provided for @topicRecoverPrompt.
  ///
  /// In en, this message translates to:
  /// **'My home was damaged. How do I start recovering and filing claims?'**
  String get topicRecoverPrompt;

  /// No description provided for @chatInputPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Type a message…'**
  String get chatInputPlaceholder;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @noConversationToShare.
  ///
  /// In en, this message translates to:
  /// **'No conversation to share yet.'**
  String get noConversationToShare;

  /// No description provided for @shareSubject.
  ///
  /// In en, this message translates to:
  /// **'Disaster AIDvisor Conversation — {date}'**
  String shareSubject(String date);

  /// No description provided for @shareHeader.
  ///
  /// In en, this message translates to:
  /// **'Disaster AIDvisor Conversation — {date}'**
  String shareHeader(String date);

  /// No description provided for @shareSpeakerYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get shareSpeakerYou;

  /// No description provided for @shareSpeakerBot.
  ///
  /// In en, this message translates to:
  /// **'AIDvisor'**
  String get shareSpeakerBot;

  /// No description provided for @menuShareConversation.
  ///
  /// In en, this message translates to:
  /// **'Share Conversation'**
  String get menuShareConversation;

  /// No description provided for @menuClearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get menuClearChat;

  /// No description provided for @menuReportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report an Issue'**
  String get menuReportIssue;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get menuLogout;

  /// No description provided for @menuDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get menuDeleteAccount;

  /// No description provided for @menuTermsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get menuTermsConditions;

  /// No description provided for @menuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// No description provided for @homeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Return to home'**
  String get homeTooltip;

  /// No description provided for @clearChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get clearChatTitle;

  /// No description provided for @clearChatBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your entire conversation history. Continue?'**
  String get clearChatBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @inputDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disaster AIDvisor is for general informational purposes only and is not a substitute for emergency services — if you are in immediate danger, please call 911.'**
  String get inputDisclaimer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
