import 'package:pokemate/ui/views/unknown/unknown_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:pokemate/ui/views/navigation/navigation_view.dart';
import 'package:pokemate/services/page_storage_service.dart';
import 'package:pokemate/services/settings_service.dart';
import 'package:pokemate/services/pokemon_data_service.dart';
import 'package:pokemate/services/backend_api_service.dart';
import 'package:pokemate/services/custom_snackbar_service.dart';
import 'package:pokemate/services/custom_dialog_service.dart';
import 'package:pokemate/ui/views/initialization_error/initialization_error_view.dart';
import 'package:pokemate/services/custom_bottom_sheet_service.dart';
import 'package:pokemate/services/web_outdated_cache_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: NavigationView, initial: true),
    MaterialRoute(page: InitializationErrorView),
// @stacked-route

    CustomRoute(page: UnknownView, path: '/404'),

    /// When none of the above routes match, redirect to UnknownView
    RedirectRoute(path: '*', redirectTo: '/404'),
  ],
  dependencies: [
    LazySingleton(classType: RouterService),
    LazySingleton(classType: PageStorageService),
    LazySingleton(classType: SettingsService),
    LazySingleton(classType: PokemonDataService),
    LazySingleton(classType: BackendApiService),
    LazySingleton(classType: CustomSnackbarService),
    LazySingleton(classType: CustomDialogService),
    LazySingleton(classType: CustomBottomSheetService),
    LazySingleton(classType: WebOutdatedCacheService),
// @stacked-service
  ],
)
class App {}
