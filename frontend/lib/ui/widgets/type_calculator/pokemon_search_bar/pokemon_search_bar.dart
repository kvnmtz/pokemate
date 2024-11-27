import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/ui/views/type_calculator/type_calculator_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PokemonSearchBar extends ViewModelWidget<TypeCalculatorViewModel> {
  const PokemonSearchBar({super.key});

  @override
  Widget build(BuildContext context, TypeCalculatorViewModel viewModel) {
    final focusNode = FocusScopeNode();
    bool didJustDismiss = false;

    return FocusScope(
      node: focusNode,
      onFocusChange: (isFocused) {
        if (didJustDismiss && isFocused) {
          didJustDismiss = false;
          focusNode.unfocus();
        }
      },
      child: SearchAnchor(
        searchController: viewModel.searchController,
        builder: (_, controller) {
          return SearchBar(
            controller: viewModel.searchController,
            elevation: const WidgetStatePropertyAll(0),
            leading: const Icon(Icons.search),
            hintText: context.t.searchPokemon,
            onTapOutside: (_) => context.focusScope.unfocus(),
            onTap: () {
              controller.openView();
            },
            onChanged: (value) {
              controller.openView();
            },
          );
        },
        suggestionsBuilder: (_, controller) {
          viewModel.searchPokemon(controller.text, context);
          return List<ListTile>.generate(viewModel.searchResults.length, (int idx) {
            var pokemon = viewModel.searchResults[idx];
            return ListTile(
              title: Text(pokemon.getName()),
              leading: SizedBox(
                width: 40,
                height: 40,
                child: pokemon.getSprite(),
              ),
              trailing: LayoutBuilder(builder: (context, _) {
                final screenWidth = context.mediaQuery.size.width;

                if (screenWidth > 600) {
                  return SizedBox(
                    width: 208, // 2*100 (images) + 8 (spacing)
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/type_icons/type_${pokemon.firstType}_${context.locale.languageCode}.png',
                          width: 100,
                        ),
                        const SizedBox(width: 8),
                        pokemon.secondType == 'none'
                            ? const SizedBox(width: 100)
                            : Image.asset(
                                'assets/images/type_icons/type_${pokemon.secondType}_${context.locale.languageCode}.png',
                                width: 100,
                              ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/type_icons/type_${pokemon.firstType}_${context.locale.languageCode}.png',
                          width: 100,
                        ),
                        if (pokemon.secondType != 'none') const SizedBox(height: 4),
                        if (pokemon.secondType != 'none')
                          Image.asset(
                            'assets/images/type_icons/type_${pokemon.secondType}_${context.locale.languageCode}.png',
                            width: 100,
                          ),
                      ],
                    ),
                  );
                }
              }),
              onTap: () {
                didJustDismiss = true;
                context.focusScope.unfocus();
                viewModel.onSearchResultTap(
                  pokemon: pokemon,
                  context: context,
                );
              },
            );
          });
        },
      ),
    );
  }
}
