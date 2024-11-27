import 'package:flutter/material.dart';
import 'package:pokemate/ui/common/persistent_view_model.dart';
import 'package:stacked/stacked.dart';

abstract class PersistentView<T extends PersistentViewModel> extends StackedView<T> {
  const PersistentView({super.key});

  String get identifier;

  @override
  bool get disposeViewModel => false;

  @override
  void onViewModelReady(T viewModel) {
    viewModel.restoreScrollOffset();
  }

  @override
  void onDispose(T viewModel) {
    viewModel.persistViewModel();
  }

  @override
  T viewModelBuilder(BuildContext context) {
    return PersistentViewModel.buildViewModel(
      initial: ({required identifier}) => initialViewModelBuilder(context, identifier),
      identifier: identifier,
    );
  }

  T initialViewModelBuilder(BuildContext context, String identifier);
}
