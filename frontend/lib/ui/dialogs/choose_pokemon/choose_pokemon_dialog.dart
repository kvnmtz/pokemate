import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/common/pokemon_data/generation.dart';
import 'package:stacked/stacked.dart';

import 'choose_pokemon_dialog_model.dart';

class SearchField extends StatefulWidget {
  final String label;
  final double width;
  final List<DropdownMenuEntry<Object?>> Function(String query) buildSuggestions;
  final TextEditingController? controller;

  const SearchField({
    super.key,
    required this.label,
    required this.width,
    required this.buildSuggestions,
    this.controller,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  List<DropdownMenuEntry<Object?>> _dropdownEntries = [];
  String lastSearchQuery = '';

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: widget.width,
      controller: widget.controller,
      enableSearch: true,
      requestFocusOnTap: true,
      leadingIcon: const Icon(Icons.search),
      label: Text(widget.label),
      searchCallback: (entries, query) {
        // To stop this callback from infinitely firing
        if (query == lastSearchQuery) return null;

        // Delay to next frame so setState won't get called during build
        Future.delayed(Duration.zero, () async {
          setState(() {
            _dropdownEntries = widget.buildSuggestions(query);
            lastSearchQuery = query;
          });
        });

        return null;
      },
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
      ),
      dropdownMenuEntries: _dropdownEntries,
      menuHeight: _dropdownEntries.isEmpty ? 0 : null, // hide menu if there are no results
    );
  }
}

class ChoosePokemonDialog extends StackedView<ChoosePokemonDialogModel> {
  final Generation generation;
  final String? species;
  final String? move1;
  final String? move2;
  final String? move3;
  final String? move4;

  const ChoosePokemonDialog({
    super.key,
    required this.generation,
    this.species,
    this.move1,
    this.move2,
    this.move3,
    this.move4,
  });

  @override
  Widget builder(BuildContext context, ChoosePokemonDialogModel viewModel, Widget? child) {
    return LayoutBuilder(builder: (context, _) {
      final screenWidth = context.mediaQuery.size.width;
      var dialogWidth = screenWidth;

      if (dialogWidth > 700) {
        dialogWidth = 700;
      }

      return Dialog(
        child: SizedBox(
          width: dialogWidth,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pokémon',
                    style: context.theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  SearchField(
                    label: context.t.species,
                    width: dialogWidth - 32 * 2,
                    buildSuggestions: viewModel.buildSpeciesSuggestions,
                    controller: viewModel.speciesController,
                  ),
                  const SizedBox(height: 16),
                  SearchField(
                    label: context.t.attackNoX(1),
                    width: dialogWidth - 32 * 2,
                    buildSuggestions: viewModel.buildMoveSuggestions,
                    controller: viewModel.move1Controller,
                  ),
                  const SizedBox(height: 8),
                  SearchField(
                    label: context.t.attackNoX(2),
                    width: dialogWidth - 32 * 2,
                    buildSuggestions: viewModel.buildMoveSuggestions,
                    controller: viewModel.move2Controller,
                  ),
                  const SizedBox(height: 8),
                  SearchField(
                    label: context.t.attackNoX(3),
                    width: dialogWidth - 32 * 2,
                    buildSuggestions: viewModel.buildMoveSuggestions,
                    controller: viewModel.move3Controller,
                  ),
                  const SizedBox(height: 8),
                  SearchField(
                    label: context.t.attackNoX(4),
                    width: dialogWidth - 32 * 2,
                    buildSuggestions: viewModel.buildMoveSuggestions,
                    controller: viewModel.move4Controller,
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: viewModel.cancel,
                        label: Text(context.t.cancel),
                        icon: const Icon(Icons.close),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: viewModel.remove,
                        label: Text(context.t.remove),
                        icon: const Icon(Icons.delete),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: viewModel.submit,
                        label: Text(context.t.submit),
                        icon: const Icon(Icons.check),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  ChoosePokemonDialogModel viewModelBuilder(BuildContext context) {
    return ChoosePokemonDialogModel(
      generation: generation,
      species: species,
      move1: move1,
      move2: move2,
      move3: move3,
      move4: move4,
    );
  }
}
