import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/common/pokemon_data/pokemon_types.dart';
import 'package:pokemate/services/pokemon_data_service.dart';
import 'package:pokemate/ui/views/type_calculator/type_calculator_viewmodel.dart';
import 'package:pokemate/ui/widgets/type_calculator/type_radio_button/type_radio_button.dart';
import 'package:stacked/stacked.dart';

class TypeSelection extends ViewModelWidget<TypeCalculatorViewModel> {
  const TypeSelection({super.key});

  @override
  Widget build(BuildContext context, TypeCalculatorViewModel viewModel) {
    final pokemonDataService = locator<PokemonDataService>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.firstType,
          style: context.theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: List<TypeRadioButton>.generate(
            PokemonType.values.length,
            (int idx) {
              final currentType = PokemonType.values[idx];
              return TypeRadioButton(
                value: currentType,
                groupValue: viewModel.firstType,
                onTap: () => viewModel.onSelectFirstType(currentType),
                isDisabled: false,
                isVisible: !pokemonDataService.isTypeInvalidForGeneration(type: currentType, generation: viewModel.selectedGeneration),
              );
            },
          ).where((element) => element.isVisible).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          context.t.secondType,
          style: context.theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: List<TypeRadioButton>.generate(
            PokemonType.values.length + 1,
            (int idx) {
              final currentType = idx == PokemonType.values.length ? null : PokemonType.values[idx];
              final isTypeAlreadySelectedAsFirst = currentType == viewModel.firstType;
              return TypeRadioButton(
                value: currentType,
                groupValue: viewModel.secondType,
                onTap: () => viewModel.onSelectSecondType(currentType),
                isDisabled: isTypeAlreadySelectedAsFirst,
                isVisible: currentType == null || !pokemonDataService.isTypeInvalidForGeneration(type: currentType, generation: viewModel.selectedGeneration),
              );
            },
          ).where((element) => element.isVisible).toList(),
        ),
      ],
    );
  }
}
