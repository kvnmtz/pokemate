import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/global.dart';
import 'package:pokemate/services/backend_api_service.dart';
import 'package:pokemate/services/custom_snackbar_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginDialogModel extends BaseViewModel {
  final _snackbarService = locator<CustomSnackbarService>();
  final _routerService = locator<RouterService>();
  final _backendApiService = locator<BackendApiService>();

  final _usernameController = TextEditingController();
  TextEditingController get usernameController => _usernameController;

  final _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  bool _registerNewAccount = false;
  bool get registerNewAccount => _registerNewAccount;

  void setRegisterNewAccount(bool state) {
    _registerNewAccount = state;
    rebuildUi();
  }

  void loginOrRegister() async {
    try {
      final username = _usernameController.text;
      final password = _passwordController.text;
      final result = _registerNewAccount
          ? await _backendApiService.register(
              username: username,
              password: password,
            )
          : await _backendApiService.login(
              username: username,
              password: password,
            );

      if (result.isNotSuccessful) {
        _snackbarService.showDetailedErrorSnackBar(
          message: _registerNewAccount ? l10n.errorRegistrationFailed : l10n.errorLoginFailed,
          detailedMessage: result.errorMessage,
        );
        return;
      }

      _routerService.back(result: true);
    } catch (e) {
      _snackbarService.showDetailedErrorSnackBar(
        message: _registerNewAccount ? l10n.errorRegistrationFailed : l10n.errorLoginFailed,
        detailedMessage: e.toString(),
      );
    }
  }
}
