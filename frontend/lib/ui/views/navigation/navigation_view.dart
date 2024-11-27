import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/services/page_storage_service.dart';
import 'package:stacked/stacked.dart';

import 'navigation_viewmodel.dart';

class NavigationView extends StackedView<NavigationViewModel> {
  const NavigationView({super.key});

  @override
  void onViewModelReady(NavigationViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.initialize();
  }

  @override
  Widget builder(BuildContext context, NavigationViewModel viewModel, Widget? child) {
    return SafeArea(
      child: Scaffold(
        body: PageStorage(
          key: locator<PageStorageService>().pageStorageKey,
          bucket: viewModel.pageStorageBucket,
          child: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              secondaryAnimation.addStatusListener(viewModel.transitionStatusListener);
              return FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: viewModel.getCurrentPageWidget(),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
              selectedIcon: const Icon(Icons.calculate),
              icon: const Icon(Icons.calculate_outlined),
              label: context.t.typeCalculator,
              tooltip: '',
            ),
            NavigationDestination(
              selectedIcon: const Icon(Icons.catching_pokemon),
              icon: const Icon(Icons.catching_pokemon_outlined),
              label: context.t.teamBuilder,
              tooltip: '',
            ),
            NavigationDestination(
              selectedIcon: const Icon(Icons.settings),
              icon: const Icon(Icons.settings_outlined),
              label: context.t.settings,
              tooltip: '',
            ),
          ],
          selectedIndex: viewModel.currentPageIndex,
          onDestinationSelected: viewModel.isTransitioning ? null : viewModel.onDestinationSelected,
        ),
      ),
    );
  }

  @override
  NavigationViewModel viewModelBuilder(BuildContext context) => NavigationViewModel();
}
