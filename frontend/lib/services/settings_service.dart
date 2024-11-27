import 'package:flutter/material.dart';
import 'package:pokemate/global.dart';
import 'package:stacked/stacked.dart';

class SettingsService with ListenableServiceMixin {
  Future<void> initialize() async {
    if (!prefs.containsKey('dark_mode')) {
      await prefs.setBool('dark_mode', true);
    }
    _darkMode = prefs.getBool('dark_mode')!;

    if (!prefs.containsKey('locale')) {
      await prefs.setString('locale', 'en');
    }
    _locale = Locale(prefs.getString('locale')!);

    if (!prefs.containsKey('multi_language_search')) {
      await prefs.setBool('multi_language_search', false);
    }
    _multiLanguageSearch = prefs.getBool('multi_language_search')!;

    listenToReactiveValues([
      _darkMode,
      _locale,
      _multiLanguageSearch,
    ]);
  }

  late bool _darkMode;
  bool get darkMode => _darkMode;

  void setDarkMode(bool state) async {
    _darkMode = state;
    await prefs.setBool('dark_mode', state);
    notifyListeners();
  }

  late Locale _locale;
  Locale get locale => _locale;

  void setLocale(Locale locale) async {
    _locale = locale;
    await prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  late bool _multiLanguageSearch;
  bool get multiLanguageSearch => _multiLanguageSearch;

  void setMutliLanguageSearch(bool state) async {
    _multiLanguageSearch = state;
    await prefs.setBool('multi_language_search', state);
    notifyListeners();
  }
}
