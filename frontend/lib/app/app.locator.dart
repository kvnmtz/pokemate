// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/navigation/router_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../services/backend_api_service.dart';
import '../services/custom_bottom_sheet_service.dart';
import '../services/custom_dialog_service.dart';
import '../services/custom_snackbar_service.dart';
import '../services/page_storage_service.dart';
import '../services/pokemon_data_service.dart';
import '../services/settings_service.dart';
import '../services/web_outdated_cache_service.dart';
import 'app.router.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
  StackedRouterWeb? stackedRouter,
}) async {
// Register environments
  locator.registerEnvironment(environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => RouterService());
  locator.registerLazySingleton(() => PageStorageService());
  locator.registerLazySingleton(() => SettingsService());
  locator.registerLazySingleton(() => PokemonDataService());
  locator.registerLazySingleton(() => BackendApiService());
  locator.registerLazySingleton(() => CustomSnackbarService());
  locator.registerLazySingleton(() => CustomDialogService());
  locator.registerLazySingleton(() => CustomBottomSheetService());
  locator.registerLazySingleton(() => WebOutdatedCacheService());
  if (stackedRouter == null) {
    throw Exception('Stacked is building to use the Router (Navigator 2.0) navigation but no stackedRouter is supplied. Pass the stackedRouter to the setupLocator function in main.dart');
  }

  locator<RouterService>().setRouter(stackedRouter);
}
