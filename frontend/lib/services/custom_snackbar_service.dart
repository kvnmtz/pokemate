import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/app/app.router.dart';
import 'package:pokemate/services/custom_bottom_sheet_service.dart';
import 'package:pokemate/ui/bottom_sheets/error_details_sheet/error_details_sheet.dart';

class CustomSnackbarService {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showCustomSnackBar(
    SnackBar snackBar, {
    AnimationStyle? snackBarAnimationStyle,
  }) {
    return ScaffoldMessenger.of(stackedRouter.navigatorKey.currentContext!).showSnackBar(
      snackBar,
      snackBarAnimationStyle: snackBarAnimationStyle,
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackBar({
    required String message,
  }) {
    return ScaffoldMessenger.of(stackedRouter.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Color(0xFFFFFFFF)),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 5000),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        showCloseIcon: false,
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar({
    required String message,
  }) {
    return ScaffoldMessenger.of(stackedRouter.navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Color(0xFFFFFFFF)),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 5000),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        showCloseIcon: true,
        closeIconColor: const Color(0xFFFFFFFF),
      ),
    );
  }

  final _bottomSheetService = locator<CustomBottomSheetService>();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showDetailedErrorSnackBar({
    required String message,
    required String detailedMessage,
  }) {
    return showCustomSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              color: Colors.white,
              onPressed: () => _bottomSheetService.showModalBottomSheet(
                showDragHandle: true,
                builder: (context) => ErrorDetailsSheet(
                  message: message,
                  detailedMessage: detailedMessage,
                ),
              ),
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 5000),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        showCloseIcon: false,
      ),
    );
  }
}
