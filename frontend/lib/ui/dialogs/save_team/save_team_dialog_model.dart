import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/global.dart';
import 'package:pokemate/common/pokemon_data/team_member.dart';
import 'package:pokemate/services/backend_api_service.dart';
import 'package:pokemate/services/custom_dialog_service.dart';
import 'package:pokemate/services/custom_snackbar_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SaveTeamDialogModel extends BaseViewModel {
  final int generation;
  final List<TeamMember> team;

  SaveTeamDialogModel({
    required this.generation,
    required this.team,
  });

  final _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final _snackbarService = locator<CustomSnackbarService>();
  final _dialogService = locator<CustomDialogService>();
  final _routerService = locator<RouterService>();
  final _backendApiService = locator<BackendApiService>();

  void save() async {
    final jwt = prefs.getString('jwt');
    if (jwt == null) return;

    final name = nameController.text;
    if (name.isEmpty) {
      _snackbarService.showErrorSnackBar(message: l10n.errorNoName);
      return;
    }

    try {
      var result = await _backendApiService.saveTeam(
        name: name,
        languageCode: languageCode,
        generation: generation,
        team: TeamMember.convertListToJson(team),
      );

      if (result.isNotSuccessful) {
        _snackbarService.showDetailedErrorSnackBar(
          message: l10n.errorSavingTeam,
          detailedMessage: result.errorMessage,
        );
        _routerService.back();
        return;
      }

      final needsOverwritingConfirmation = !result.data;
      if (needsOverwritingConfirmation) {
        final dialogResult = await _dialogService.showDialog(
          builder: (context) => AlertDialog(
            title: Text(context.t.overwriteTeamTitle),
            content: Text(context.t.overwriteTeamDesc),
            actions: [
              TextButton(
                onPressed: () => _routerService.back(result: false),
                child: Text(context.t.no),
              ),
              TextButton(
                onPressed: () => _routerService.back(result: true),
                child: Text(context.t.yes),
              ),
            ],
          ),
        );

        if (dialogResult != true) return;

        result = await _backendApiService.saveTeam(
          name: name,
          languageCode: languageCode,
          generation: generation,
          team: TeamMember.convertListToJson(team),
          overwrite: true,
        );
      }

      if (result.isNotSuccessful) {
        _snackbarService.showDetailedErrorSnackBar(
          message: l10n.errorSavingTeam,
          detailedMessage: result.errorMessage,
        );
        return;
      }

      _snackbarService.showSuccessSnackBar(message: l10n.successSaveTeam);
      _routerService.back();
    } catch (e) {
      _snackbarService.showDetailedErrorSnackBar(
        message: l10n.errorSavingTeam,
        detailedMessage: e.toString(),
      );
      return;
    }
  }
}
