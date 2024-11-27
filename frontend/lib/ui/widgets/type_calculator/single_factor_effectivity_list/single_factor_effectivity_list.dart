import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/ui/views/type_calculator/type_calculator_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SingleFactorEffectivityList extends ViewModelWidget<TypeCalculatorViewModel> {
  final double factor;

  const SingleFactorEffectivityList({
    super.key,
    required this.factor,
  });

  static var damageFactorSymbols = {
    0.0: '0',
    0.25: '\u00BC',
    0.5: '\u00BD',
    1.0: '1',
    2.0: '2',
    4.0: '4',
  };

  @override
  Widget build(BuildContext context, TypeCalculatorViewModel viewModel) {
    var factors = viewModel.damageFactors[factor]!;
    if (factors.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.takesXDamageFrom('${damageFactorSymbols[factor]}\u00D7'),
          style: context.theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            factors.length,
            (idx) {
              return Image.asset(
                'assets/images/type_icons/type_${factors[idx].name}_${context.locale.languageCode}.png',
                width: 100,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
