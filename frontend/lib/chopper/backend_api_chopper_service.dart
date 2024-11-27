import 'package:chopper/chopper.dart';

part 'backend_api_chopper_service.chopper.dart';

@ChopperApi()
abstract class BackendApiChopperService extends ChopperService {
  static BackendApiChopperService create([ChopperClient? client]) => _$BackendApiChopperService(client);

  @Get(path: '/data')
  Future<Response> getPokemonData();

  @Get(path: '/team-builder')
  Future<Response> getTeams({
    @Query('language') required String languageCode,
    @Header('Authorization') required String authorization,
  });

  @Delete(path: '/team-builder/{teamId}')
  Future<Response> deleteTeam({
    @Path() required String teamId,
    @Header('Authorization') required String authorization,
  });

  @Post(
    path: '/auth/login',
    headers: {
      'Content-Type': 'application/json',
    },
  )
  Future<Response> login({
    @Body() required String jsonEncodedBody,
  });

  @Post(
    path: '/auth/register',
    headers: {
      'Content-Type': 'application/json',
    },
  )
  Future<Response> register({
    @Body() required String jsonEncodedBody,
  });

  @Post(
    path: '/team-builder',
    headers: {
      'Content-Type': 'application/json',
    },
  )
  Future<Response> saveTeam({
    @Body() required String jsonEncodedBody,
    @Header('Authorization') required String authorization,
  });

  @Get(path: '/frontend-version')
  Future<Response> getServedFrontendVersion();
}
