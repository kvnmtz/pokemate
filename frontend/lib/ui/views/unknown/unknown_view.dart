import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:stacked/stacked.dart';

import 'unknown_viewmodel.dart';

class UnknownView extends StackedView<UnknownViewModel> {
  const UnknownView({super.key});

  @override
  void onViewModelReady(UnknownViewModel viewModel) {
    super.onViewModelReady(viewModel);
    FlutterNativeSplash.remove();
  }

  @override
  Widget builder(BuildContext context, UnknownViewModel viewModel, Widget? child) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '404',
              style: TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.w800,
                letterSpacing: 20.0,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'PAGE NOT FOUND',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                letterSpacing: 20.0,
                wordSpacing: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  UnknownViewModel viewModelBuilder(BuildContext context) => UnknownViewModel();
}
