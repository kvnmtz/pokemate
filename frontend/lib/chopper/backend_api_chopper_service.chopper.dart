// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_api_chopper_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$BackendApiChopperService extends BackendApiChopperService {
  _$BackendApiChopperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = BackendApiChopperService;

  @override
  Future<Response<dynamic>> getPokemonData() {
    final Uri $url = Uri.parse('/data');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getTeams({
    required String languageCode,
    required String authorization,
  }) {
    final Uri $url = Uri.parse('/team-builder');
    final Map<String, dynamic> $params = <String, dynamic>{'language': languageCode};
    final Map<String, String> $headers = {
      'Authorization': authorization,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteTeam({
    required String teamId,
    required String authorization,
  }) {
    final Uri $url = Uri.parse('/team-builder/${teamId}');
    final Map<String, String> $headers = {
      'Authorization': authorization,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> login({required String jsonEncodedBody}) {
    final Uri $url = Uri.parse('/auth/login');
    final Map<String, String> $headers = {
      'Content-Type': 'application/json',
    };
    final $body = jsonEncodedBody;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> register({required String jsonEncodedBody}) {
    final Uri $url = Uri.parse('/auth/register');
    final Map<String, String> $headers = {
      'Content-Type': 'application/json',
    };
    final $body = jsonEncodedBody;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> saveTeam({
    required String jsonEncodedBody,
    required String authorization,
  }) {
    final Uri $url = Uri.parse('/team-builder');
    final Map<String, String> $headers = {
      'Authorization': authorization,
      'Content-Type': 'application/json',
    };
    final $body = jsonEncodedBody;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getServedFrontendVersion() {
    final Uri $url = Uri.parse('/frontend-version');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
