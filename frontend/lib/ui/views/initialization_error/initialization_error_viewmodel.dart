import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/app/app.router.dart';
import 'package:pokemate/services/pokemon_data_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class InitializationErrorViewModel extends BaseViewModel {
  final _routerService = locator<RouterService>();

  bool _retrying = false;
  bool get retrying => _retrying;

  void _setRetrying(bool state) {
    _retrying = state;
    rebuildUi();
  }

  void retry() async {
    _setRetrying(true);
    final success = await locator<PokemonDataService>().initialize(retry: true);
    if (success) {
      _routerService.replaceWithNavigationView();
    } else {
      _setRetrying(false);
    }
  }
}
