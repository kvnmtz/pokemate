import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pokemate/chopper/backend_api_chopper_service.dart';
import 'package:pokemate/global.dart';
import 'package:pokemate/services/pokemon_data_service.dart';
import 'package:pokemate/services/settings_service.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/app/app.router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> initializeDotEnv() async {
  await dotenv.load();

  final requiredVariables = [
    'BACKEND_BASE_URL',
  ];

  List<String> missingVariables = [];
  for (var variable in requiredVariables) {
    if (dotenv.env[variable] == null) {
      missingVariables.add(variable);
    }
  }
  if (missingVariables.isNotEmpty) {
    var message = 'Missing .env variables: ';
    for (var i = 0; i < missingVariables.length; i++) {
      final variable = missingVariables[i];
      if (i != 0) message += ', ';
      message += variable;
    }
    throw StateError(message);
  }
}

void initializeNetworking() {
  locator.registerLazySingleton(
    () => ChopperClient(
      baseUrl: Uri.parse(dotenv.get('BACKEND_BASE_URL')),
      services: [
        BackendApiChopperService.create(),
      ],
      converter: const JsonConverter(),
    ),
  );

  locator.registerLazySingleton(
    () => locator<ChopperClient>().getService<BackendApiChopperService>(),
  );
}

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  setPathUrlStrategy();
  await setupLocator(stackedRouter: stackedRouter);

  await initializeDotEnv();

  initializeNetworking();

  prefs = await SharedPreferences.getInstance();

  await locator<SettingsService>().initialize();
  if (!await locator<PokemonDataService>().initialize()) {
    locator<RouterService>().replaceWithInitializationErrorView();
  }

  runApp(const MainApp());
}

class MainAppViewModel extends ReactiveViewModel {
  final _settingsService = locator<SettingsService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [
        _settingsService,
      ];

  bool get darkMode => _settingsService.darkMode;
  Locale get locale => _settingsService.locale;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveApp(
      builder: (_) => ViewModelBuilder.reactive(
        viewModelBuilder: () => MainAppViewModel(),
        builder: (context, viewModel, child) {
          return MaterialApp.router(
            title: 'PokéMate',
            routerDelegate: stackedRouter.delegate(),
            routeInformationParser: stackedRouter.defaultRouteParser(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: viewModel.darkMode ? ThemeMode.dark : ThemeMode.light,
            locale: viewModel.locale,
          );
        },
      ),
    ).animate().fadeIn(
          delay: const Duration(milliseconds: 50),
          duration: const Duration(milliseconds: 400),
        );
  }
}
