// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i6;
import 'package:stacked/stacked.dart' as _i5;
import 'package:stacked_services/stacked_services.dart' as _i4;

import '../ui/views/initialization_error/initialization_error_view.dart' as _i2;
import '../ui/views/navigation/navigation_view.dart' as _i1;
import '../ui/views/unknown/unknown_view.dart' as _i3;

final stackedRouter = StackedRouterWeb(navigatorKey: _i4.StackedService.navigatorKey);

class StackedRouterWeb extends _i5.RootStackRouter {
  StackedRouterWeb({_i6.GlobalKey<_i6.NavigatorState>? navigatorKey}) : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    NavigationViewRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.NavigationView(),
      );
    },
    InitializationErrorViewRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.InitializationErrorView(),
      );
    },
    UnknownViewRoute.name: (routeData) {
      return _i5.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i3.UnknownView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(
          NavigationViewRoute.name,
          path: '/',
        ),
        _i5.RouteConfig(
          InitializationErrorViewRoute.name,
          path: '/initialization-error-view',
        ),
        _i5.RouteConfig(
          UnknownViewRoute.name,
          path: '/404',
        ),
        _i5.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/404',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.NavigationView]
class NavigationViewRoute extends _i5.PageRouteInfo<void> {
  const NavigationViewRoute()
      : super(
          NavigationViewRoute.name,
          path: '/',
        );

  static const String name = 'NavigationView';
}

/// generated route for
/// [_i2.InitializationErrorView]
class InitializationErrorViewRoute extends _i5.PageRouteInfo<void> {
  const InitializationErrorViewRoute()
      : super(
          InitializationErrorViewRoute.name,
          path: '/initialization-error-view',
        );

  static const String name = 'InitializationErrorView';
}

/// generated route for
/// [_i3.UnknownView]
class UnknownViewRoute extends _i5.PageRouteInfo<void> {
  const UnknownViewRoute()
      : super(
          UnknownViewRoute.name,
          path: '/404',
        );

  static const String name = 'UnknownView';
}

extension RouterStateExtension on _i4.RouterService {
  Future<dynamic> navigateToNavigationView({void Function(_i5.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const NavigationViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToInitializationErrorView({void Function(_i5.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const InitializationErrorViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> navigateToUnknownView({void Function(_i5.NavigationFailure)? onFailure}) async {
    return navigateTo(
      const UnknownViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithNavigationView({void Function(_i5.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const NavigationViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithInitializationErrorView({void Function(_i5.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const InitializationErrorViewRoute(),
      onFailure: onFailure,
    );
  }

  Future<dynamic> replaceWithUnknownView({void Function(_i5.NavigationFailure)? onFailure}) async {
    return replaceWith(
      const UnknownViewRoute(),
      onFailure: onFailure,
    );
  }
}
