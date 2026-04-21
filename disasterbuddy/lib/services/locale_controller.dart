import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide locale override. `null` means "follow device locale".
class LocaleController extends ChangeNotifier {
  static const _prefsKey = 'app_locale_code';
  static const supportedLocales = [Locale('en'), Locale('es')];

  LocaleController._();
  static final LocaleController instance = LocaleController._();

  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale? locale) async {
    debugPrint('[LocaleController] setLocale -> ${locale?.languageCode}');
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_prefsKey);
    } else {
      await prefs.setString(_prefsKey, locale.languageCode);
    }
    if (locale != null) {
      Get.updateLocale(locale);
    }
    notifyListeners();
    debugPrint('[LocaleController] notifyListeners fired; locale now ${_locale?.languageCode}');
  }
}
