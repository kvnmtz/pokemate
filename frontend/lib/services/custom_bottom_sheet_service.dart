import 'package:flutter/material.dart' as m;
import 'package:pokemate/app/app.router.dart';

const double _defaultScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;

class CustomBottomSheetService {
  Future<T?> showModalBottomSheet<T>({
    required m.WidgetBuilder builder,
    m.Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    m.ShapeBorder? shape,
    m.Clip? clipBehavior,
    m.BoxConstraints? constraints,
    m.Color? barrierColor,
    bool isScrollControlled = false,
    double scrollControlDisabledMaxHeightRatio = _defaultScrollControlDisabledMaxHeightRatio,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
    m.RouteSettings? routeSettings,
    m.AnimationController? transitionAnimationController,
    m.Offset? anchorPoint,
    m.AnimationStyle? sheetAnimationStyle,
  }) {
    return m.showModalBottomSheet(
      context: stackedRouter.navigatorKey.currentContext!,
      builder: builder,
      backgroundColor: backgroundColor,
      barrierLabel: barrierLabel,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      sheetAnimationStyle: sheetAnimationStyle,
    );
  }
}
