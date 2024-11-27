import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:stacked/stacked.dart';

import 'initialization_error_viewmodel.dart';

class InitializationErrorView extends StackedView<InitializationErrorViewModel> {
  const InitializationErrorView({super.key});

  @override
  void onViewModelReady(InitializationErrorViewModel viewModel) {
    super.onViewModelReady(viewModel);
    FlutterNativeSplash.remove();
  }

  @override
  Widget builder(BuildContext context, InitializationErrorViewModel viewModel, Widget? child) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                size: 48,
              ),
              const SizedBox(height: 32),
              Text(
                kIsWeb ? context.t.initializationErrorDescriptionWeb : context.t.initializationErrorDescription,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (viewModel.retrying)
                const CircularProgressIndicator()
              else
                FilledButton.tonalIcon(
                  onPressed: viewModel.retrying ? null : viewModel.retry,
                  label: Text(context.t.tryAgain),
                  icon: const Icon(Icons.refresh),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  InitializationErrorViewModel viewModelBuilder(BuildContext context) => InitializationErrorViewModel();
}
