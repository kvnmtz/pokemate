import 'package:flutter/material.dart';
import 'package:pokemate/ui/widgets/type_calculator/effectivity_list/effectivity_list.dart';
import 'package:pokemate/ui/widgets/common/generation_picker/generation_picker.dart';
import 'package:pokemate/ui/widgets/type_calculator/pokemon_search_bar/pokemon_search_bar.dart';
import 'package:pokemate/ui/widgets/type_calculator/type_selection/type_selection.dart';
import 'package:stacked/stacked.dart';

import 'type_calculator_viewmodel.dart';

class TypeCalculatorViewMobile extends ViewModelWidget<TypeCalculatorViewModel> {
  const TypeCalculatorViewMobile({super.key});

  @override
  Widget build(BuildContext context, TypeCalculatorViewModel viewModel) {
    return Column(
      children: [
        Column(
          children: [
            const PokemonSearchBar(),
            const SizedBox(height: 16),
            GenerationPicker(
              onSelected: viewModel.onSelectGeneration,
              selectedGeneration: viewModel.selectedGeneration,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypeSelection(),
            Divider(height: 32),
            EffectivityList(),
          ],
        )
      ],
    );
  }
}
