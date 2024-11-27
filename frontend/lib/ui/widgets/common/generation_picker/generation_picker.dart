import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/common/pokemon_data/generation.dart';
import 'package:pokemate/services/pokemon_data_service.dart';

class GenerationPicker extends StatefulWidget {
  final Generation selectedGeneration;
  final Function(Generation?) onSelected;

  const GenerationPicker({
    super.key,
    required this.selectedGeneration,
    required this.onSelected,
  });

  @override
  State<GenerationPicker> createState() => _GenerationPickerState();
}

class _GenerationPickerState extends State<GenerationPicker> {
  final _controller = TextEditingController();

  String _getLabel(Generation generation) {
    return 'Generation ${generation.number} (${generation.getExamples()})';
  }

  void _updateDisplayText() {
    _controller.text = _getLabel(widget.selectedGeneration);
  }

  @override
  void didUpdateWidget(covariant GenerationPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGeneration == widget.selectedGeneration) return;

    _updateDisplayText();
  }

  @override
  Widget build(BuildContext context) {
    _updateDisplayText();
    return DropdownMenu<Generation>(
      controller: _controller,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
      ),
      leadingIcon: const Icon(Icons.sports_esports),
      dropdownMenuEntries: locator<PokemonDataService>().allGenerations.map<DropdownMenuEntry<Generation>>((Generation generation) {
        return DropdownMenuEntry<Generation>(
          value: generation,
          label: _getLabel(generation),
          enabled: generation.number != widget.selectedGeneration.number,
        );
      }).toList(),
      expandedInsets: EdgeInsets.zero, // expands the menu to full width
      requestFocusOnTap: false, // disables text input
      onSelected: widget.onSelected,
    );
  }
}
