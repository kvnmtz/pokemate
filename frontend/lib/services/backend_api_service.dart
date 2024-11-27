import 'dart:convert';

import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/chopper/backend_api_chopper_service.dart';
import 'package:pokemate/common/network_result.dart';
import 'package:pokemate/global.dart';
import 'package:pokemate/ui/dialogs/load_team/load_team_dialog_model.dart';

class BackendApiService {
  final _backendApiChopperService = locator<BackendApiChopperService>();

  Future<NetworkResult<Map<String, dynamic>>> getPokemonData() async {
    try {
      final response = await _backendApiChopperService.getPokemonData();
      if (response.statusCode != 200) {
        return NetworkResult.wrongStatusCode(response.statusCode);
      }

      return NetworkResult.success(response.body);
    } on Exception catch (e) {
      return NetworkResult.exception(e);
    }
  }

  Future<NetworkResult<List<Team>>> getTeams({
    required String languageCode,
  }) async {
    try {
      final jwt = prefs.getString('jwt');
      if (jwt == null) {
        return NetworkResult.exception(Exception('Unable to find JWT'));
      }

      final response = await _backendApiChopperService.getTeams(
        languageCode: languageCode,
        authorization: 'Bearer $jwt',
      );
      final status = response.statusCode;
      if (status == 403) {
        prefs.remove('jwt');
        return NetworkResult.exception(Exception(l10n.errorSessionInvalid));
      } else if (status != 200) {
        return NetworkResult.wrongStatusCode(status);
      }

      final data = (response.body as List).map((e) => e as Map<String, dynamic>).toList();
      return NetworkResult.success(data.map((json) => Team.fromJson(json)).toList());
    } on Exception catch (e) {
      return NetworkResult.exception(e);
    }
  }

  Future<NetworkResult<void>> deleteTeam({
    required String teamId,
  }) async {
    try {
      final jwt = prefs.getString('jwt');
      if (jwt == null) {
        return NetworkResult.exception(Exception('Unable to find JWT'));
      }

      final response = await _backendApiChopperService.deleteTeam(
        teamId: teamId,
        authorization: 'Bearer $jwt',
      );
      final status = response.statusCode;
      if (status == 403) {
        prefs.remove('jwt');
        return NetworkResult.exception(Exception(l10n.errorSessionInvalid));
      } else if (status != 204) {
        return NetworkResult.wrongStatusCode(status);
      }

      return NetworkResult.success();
    } on Exception catch (e) {
      return NetworkResult.exception(e);
    }
  }

  Future<NetworkResult<void>> login({
    required String username,
    required String password,
  }) async {
    try {
      final body = jsonEncode({
        'username': username,
        'password': password,
      });

      final response = await _backendApiChopperService.login(
        jsonEncodedBody: body,
      );
      if (response.statusCode != 200) {
        return NetworkResult.wrongStatusCode(response.statusCode);
      }

      await prefs.setString('jwt', response.body['jwt']);
      return NetworkResult.success();
    } on Exception catch (e) {
      return NetworkResult.exception(e);
    }
  }

  Future<NetworkResult<void>> register({
    required String username,
    required String password,
  }) async {
    try {
      final body = jsonEncode({
        'username': username,
        'password': password,
      });

      final response = await _backendApiChopperService.register(
        jsonEncodedBody: body,
      );
      if (response.statusCode != 200) {
        return NetworkResult.wrongStatusCode(response.statusCode);
      }

      await prefs.setString('jwt', response.body['jwt']);
      return NetworkResult.success();
    } on Exception catch (e) {
      return NetworkResult.exception(e);
    }
  }

  /// If this returns false, confirmation for overwriting an already existing team is necessary
  Future<NetworkResult<bool>> saveTeam({
    required String name,
    required String languageCode,
    required int generation,
    required List<Map<String, dynamic>> team,
    bool overwrite = false,
  }) async {
    try {
      final jwt = prefs.getString('jwt');
      if (jwt == null) {
        return NetworkResult.exception(Exception('Unable to find JWT'));
      }

      final body = jsonEncode({
        'name': name,
        'language': languageCode,
        'generation': generation,
        'team': team,
        if (overwrite) 'overwrite': true,
      });

      final response = await _backendApiChopperService.saveTeam(
        jsonEncodedBody: body,
        authorization: 'Bearer $jwt',
      );
      final status = response.statusCode;
      if (status == 403) {
        prefs.remove('jwt');
        return NetworkResult.exception(Exception(l10n.errorSessionInvalid));
      } else if (status == 400) {
        return NetworkResult.success(false);
      } else if (status != 204) {
        return NetworkResult.wrongStatusCode(status);
      }

      return NetworkResult.success(true);
    } on Exception catch (e) {
      return NetworkResult.exception(e);
    }
  }
}
