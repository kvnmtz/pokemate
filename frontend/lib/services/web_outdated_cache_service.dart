import 'package:flutter/foundation.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/chopper/backend_api_chopper_service.dart';
import 'package:pokemate/common/network_result.dart';

class WebOutdatedCacheService {
  Future<NetworkResult<bool>> isCachedFrontendOutdated() async {
    try {
      final response = await locator<BackendApiChopperService>().getServedFrontendVersion();
      if (response.statusCode != 200) {
        return NetworkResult.wrongStatusCode(response.statusCode);
      }

      final servedFrontendVersion = response.body;

      const actualVersion = String.fromEnvironment('VERSION');

      return NetworkResult.success(actualVersion != servedFrontendVersion);
    } on Exception catch (e) {
      if (kDebugMode) rethrow;
      return NetworkResult.exception(e);
    }
  }
}
