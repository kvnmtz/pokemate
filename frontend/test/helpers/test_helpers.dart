import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:pokemate/services/page_storage_service.dart';
import 'package:pokemate/services/settings_service.dart';
import 'package:pokemate/services/pokemon_data_service.dart';
import 'package:pokemate/services/backend_api_service.dart';
import 'package:pokemate/services/custom_snackbar_service.dart';
import 'package:pokemate/services/custom_dialog_service.dart';
import 'package:pokemate/services/custom_bottom_sheet_service.dart';
import 'package:pokemate/services/web_outdated_cache_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<RouterService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<PageStorageService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SettingsService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<PokemonDataService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BackendApiService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<CustomSnackbarService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<CustomDialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<CustomBottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<WebOutdatedCacheService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterRouterService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterPageStorageService();
  getAndRegisterSettingsService();
  getAndRegisterPokemonDataService();
  getAndRegisterBackendApiService();
  getAndRegisterCustomSnackbarService();
  getAndRegisterCustomDialogService();
  getAndRegisterCustomBottomSheetService();
  getAndRegisterWebOutdatedCacheService();
// @stacked-mock-register
}

MockRouterService getAndRegisterRouterService() {
  _removeRegistrationIfExists<RouterService>();
  final service = MockRouterService();
  locator.registerSingleton<RouterService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) => Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockPageStorageService getAndRegisterPageStorageService() {
  _removeRegistrationIfExists<PageStorageService>();
  final service = MockPageStorageService();
  locator.registerSingleton<PageStorageService>(service);
  return service;
}

MockSettingsService getAndRegisterSettingsService() {
  _removeRegistrationIfExists<SettingsService>();
  final service = MockSettingsService();
  locator.registerSingleton<SettingsService>(service);
  return service;
}

MockPokemonDataService getAndRegisterPokemonDataService() {
  _removeRegistrationIfExists<PokemonDataService>();
  final service = MockPokemonDataService();
  locator.registerSingleton<PokemonDataService>(service);
  return service;
}

MockBackendApiService getAndRegisterBackendApiService() {
  _removeRegistrationIfExists<BackendApiService>();
  final service = MockBackendApiService();
  locator.registerSingleton<BackendApiService>(service);
  return service;
}

MockCustomSnackbarService getAndRegisterCustomSnackbarService() {
  _removeRegistrationIfExists<CustomSnackbarService>();
  final service = MockCustomSnackbarService();
  locator.registerSingleton<CustomSnackbarService>(service);
  return service;
}

MockCustomDialogService getAndRegisterCustomDialogService() {
  _removeRegistrationIfExists<CustomDialogService>();
  final service = MockCustomDialogService();
  locator.registerSingleton<CustomDialogService>(service);
  return service;
}

MockCustomBottomSheetService getAndRegisterCustomBottomSheetService() {
  _removeRegistrationIfExists<CustomBottomSheetService>();
  final service = MockCustomBottomSheetService();
  locator.registerSingleton<CustomBottomSheetService>(service);
  return service;
}

MockWebOutdatedCacheService getAndRegisterWebOutdatedCacheService() {
  _removeRegistrationIfExists<WebOutdatedCacheService>();
  final service = MockWebOutdatedCacheService();
  locator.registerSingleton<WebOutdatedCacheService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
