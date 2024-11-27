import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/services/settings_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SettingsLanguageDialogModel extends ReactiveViewModel {
  final _settingsService = locator<SettingsService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _settingsService,
      ];

  Locale get locale => _settingsService.locale;

  void setLocale(Locale locale) {
    _settingsService.setLocale(locale);
    notifyListeners();
  }

  void closeDialog() {
    locator<RouterService>().back();
  }
}
