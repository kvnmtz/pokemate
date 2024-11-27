import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/ui/common/persistent_view.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'type_calculator_view.tablet.dart';
import 'type_calculator_view.mobile.dart';
import 'type_calculator_viewmodel.dart';

class TypeCalculatorView extends PersistentView<TypeCalculatorViewModel> {
  const TypeCalculatorView({super.key});

  @override
  void onViewModelReady(TypeCalculatorViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.initialize();
  }

  @override
  Widget builder(BuildContext context, TypeCalculatorViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Scrollbar(
        interactive: true,
        controller: viewModel.scrollController,
        radius: context.theme.platform == TargetPlatform.android ? const Radius.circular(2) : null,
        child: CustomScrollView(
          controller: viewModel.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: ScreenTypeLayout.builder(
                  mobile: (_) => const TypeCalculatorViewMobile(),
                  tablet: (_) => const TypeCalculatorViewTablet(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  String get identifier => 'type_calculator';

  @override
  TypeCalculatorViewModel initialViewModelBuilder(BuildContext context, String identifier) => TypeCalculatorViewModel(identifier: identifier);
}
