import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/services/custom_dialog_service.dart';
import 'package:pokemate/services/web_outdated_cache_service.dart';
import 'package:pokemate/ui/dialogs/web_cached_frontend_outdated/web_cached_frontend_outdated_dialog.dart';
import 'package:pokemate/ui/views/settings/settings_view.dart';
import 'package:pokemate/ui/views/team_builder/team_builder_view.dart';
import 'package:pokemate/ui/views/type_calculator/type_calculator_view.dart';
import 'package:stacked/stacked.dart';

class NavigationViewModel extends BaseViewModel {
  void initialize() async {
    _alertIfCacheIsOutdated();
    FlutterNativeSplash.remove();
  }

  void _alertIfCacheIsOutdated() async {
    if (kDebugMode) return;
    if (!kIsWeb) return;

    final result = await locator<WebOutdatedCacheService>().isCachedFrontendOutdated();
    if (result.isNotSuccessful) return;

    final isCacheOutdated = result.data;
    if (!isCacheOutdated) return;

    locator<CustomDialogService>().showDialog(
      barrierDismissible: false,
      builder: (context) => const WebCachedFrontendOutdatedDialog(),
    );
  }

  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  void onDestinationSelected(int index) {
    _currentPageIndex = index;
    rebuildUi();
  }

  bool _transitioning = false;
  bool get isTransitioning => _transitioning;

  void setTransitioning(bool state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transitioning = state;
      rebuildUi();
    });
  }

  void transitionStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.forward || status == AnimationStatus.reverse) {
      setTransitioning(true);
    } else {
      setTransitioning(false);
    }
  }

  final _pageStorageBucket = PageStorageBucket();
  PageStorageBucket get pageStorageBucket => _pageStorageBucket;

  Widget getCurrentPageWidget() {
    switch (_currentPageIndex) {
      case 0:
        return const TypeCalculatorView();
      case 1:
        return const TeamBuilderView();
      case 2:
        return const SettingsView();
      default:
    }
    throw StateError('Unknown page index');
  }
}
