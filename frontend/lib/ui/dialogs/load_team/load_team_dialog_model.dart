import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/global.dart';
import 'package:pokemate/common/pokemon_data/team_member.dart';
import 'package:pokemate/services/backend_api_service.dart';
import 'package:pokemate/services/custom_snackbar_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class Team {
  final String id;
  final String name;
  final int generation;
  final List<TeamMember> team;

  Team({
    required this.id,
    required this.name,
    required this.generation,
    required this.team,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      generation: json['generation'],
      team: (json['team'] as List<dynamic>).map((member) => TeamMember.fromJson(member)).toList(),
    );
  }
}

class LoadTeamDialogModel extends BaseViewModel {
  List<Team>? _teams;
  List<Team>? get teams => _teams;

  void setTeams(List<Team>? teams) {
    _teams = teams;
    rebuildUi();
  }

  final _backendApiService = locator<BackendApiService>();
  final _routerService = locator<RouterService>();
  final _snackbarService = locator<CustomSnackbarService>();

  void initialize() async {
    try {
      final result = await _backendApiService.getTeams(
        languageCode: languageCode,
      );

      if (result.isNotSuccessful) {
        _snackbarService.showDetailedErrorSnackBar(
          message: l10n.errorLoadingTeams,
          detailedMessage: result.errorMessage,
        );
        _routerService.back();
        return;
      }

      setTeams(result.data);
      rebuildUi();
    } catch (e) {
      setTeams([]);
      rebuildUi();
      _snackbarService.showDetailedErrorSnackBar(
        message: l10n.errorLoadingTeams,
        detailedMessage: e.toString(),
      );
    }
  }

  void deleteTeam({
    required int index,
  }) async {
    try {
      final result = await _backendApiService.deleteTeam(
        teamId: _teams![index].id,
      );

      if (result.isNotSuccessful) {
        _snackbarService.showDetailedErrorSnackBar(
          message: l10n.errorDeletingTeam,
          detailedMessage: result.errorMessage,
        );
        _routerService.back();
        return;
      }

      _teams!.removeAt(index);
      rebuildUi();
    } catch (e) {
      _snackbarService.showDetailedErrorSnackBar(
        message: l10n.errorDeletingTeam,
        detailedMessage: e.toString(),
      );
    }
  }
}
