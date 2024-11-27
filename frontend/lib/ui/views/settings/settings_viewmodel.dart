import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/global.dart';
import 'package:pokemate/services/custom_dialog_service.dart';
import 'package:pokemate/services/custom_snackbar_service.dart';
import 'package:pokemate/services/settings_service.dart';
import 'package:pokemate/ui/common/persistent_view_model.dart';
import 'package:pokemate/ui/dialogs/settings_language/settings_language_dialog.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends PersistentViewModel {
  SettingsViewModel({required super.identifier});

  final _settingsService = locator<SettingsService>();
  final _snackbarService = locator<CustomSnackbarService>();
  final _dialogService = locator<CustomDialogService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _settingsService,
      ];

  bool get darkMode => _settingsService.darkMode;

  void toggleDarkMode() {
    _settingsService.setDarkMode(!darkMode);
  }

  Locale get locale => _settingsService.locale;

  void setLocale(Locale locale) {
    _settingsService.setLocale(locale);
  }

  bool get multiLanguageSearch => _settingsService.multiLanguageSearch;

  void toggleMultiLanguageSearch() {
    _settingsService.setMutliLanguageSearch(!multiLanguageSearch);
  }

  void logout() async {
    if (!prefs.containsKey('jwt')) {
      _snackbarService.showErrorSnackBar(message: l10n.errorNotLoggedIn);
      return;
    }

    await prefs.remove('jwt');
    _snackbarService.showSuccessSnackBar(message: l10n.successLogout);
  }

  void showLanguageDialog() {
    _dialogService.showDialog(
      builder: (context) => const SettingsLanguageDialog(),
    );
  }
}
