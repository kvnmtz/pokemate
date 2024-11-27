import 'package:flutter/material.dart';
import 'package:pokemate/ui/widgets/type_calculator/effectivity_list/effectivity_list.dart';
import 'package:pokemate/ui/widgets/common/generation_picker/generation_picker.dart';
import 'package:pokemate/ui/widgets/type_calculator/pokemon_search_bar/pokemon_search_bar.dart';
import 'package:pokemate/ui/widgets/type_calculator/type_selection/type_selection.dart';
import 'package:stacked/stacked.dart';

import 'type_calculator_viewmodel.dart';

class TypeCalculatorViewTablet extends ViewModelWidget<TypeCalculatorViewModel> {
  const TypeCalculatorViewTablet({super.key});

  @override
  Widget build(BuildContext context, TypeCalculatorViewModel viewModel) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: PokemonSearchBar()),
            const SizedBox(width: 32),
            Expanded(
              child: GenerationPicker(
                onSelected: viewModel.onSelectGeneration,
                selectedGeneration: viewModel.selectedGeneration,
              ),
            ),
          ],
        ),
        const Divider(height: 32),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: TypeSelection()),
            SizedBox(width: 32),
            Expanded(child: EffectivityList()),
          ],
        ),
      ],
    );
  }
}
