import 'package:flutter/material.dart';
import 'package:pokemate/ui/widgets/type_calculator/single_factor_effectivity_list/single_factor_effectivity_list.dart';

class EffectivityList extends StatelessWidget {
  const EffectivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleFactorEffectivityList(factor: 4.0),
        SingleFactorEffectivityList(factor: 2.0),
        SingleFactorEffectivityList(factor: 1.0),
        SingleFactorEffectivityList(factor: 0.5),
        SingleFactorEffectivityList(factor: 0.25),
        SingleFactorEffectivityList(factor: 0.0),
      ],
    );
  }
}
