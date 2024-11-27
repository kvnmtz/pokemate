import 'package:flutter/material.dart' as m;
import 'package:pokemate/app/app.router.dart';

class CustomDialogService {
  Future<T?> showDialog<T>({
    required m.WidgetBuilder builder,
    bool barrierDismissible = true,
    m.Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    m.RouteSettings? routeSettings,
    m.Offset? anchorPoint,
    m.TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {
    return m.showDialog(
      context: stackedRouter.navigatorKey.currentContext!,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
    );
  }
}
