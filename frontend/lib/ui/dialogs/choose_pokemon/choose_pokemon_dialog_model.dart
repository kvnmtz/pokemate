import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/global.dart';
import 'package:pokemate/common/pokemon_data/generation.dart';
import 'package:pokemate/common/pokemon_data/move.dart';
import 'package:pokemate/common/pokemon_data/pokemon.dart';
import 'package:pokemate/services/custom_snackbar_service.dart';
import 'package:pokemate/services/pokemon_data_service.dart';
import 'package:pokemate/ui/dialogs/choose_pokemon/choose_pokemon_dialog_result.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChoosePokemonDialogModel extends BaseViewModel {
  final Generation generation;
  final String? species;
  final String? move1;
  final String? move2;
  final String? move3;
  final String? move4;

  ChoosePokemonDialogModel({
    required this.generation,
    required this.species,
    required this.move1,
    required this.move2,
    required this.move3,
    required this.move4,
  })  : _speciesController = TextEditingController(text: species),
        _move1Controller = TextEditingController(text: move1),
        _move2Controller = TextEditingController(text: move2),
        _move3Controller = TextEditingController(text: move3),
        _move4Controller = TextEditingController(text: move4);

  final _pokemonDataService = locator<PokemonDataService>();
  final _snackbarService = locator<CustomSnackbarService>();
  final _routerService = locator<RouterService>();

  final TextEditingController _speciesController;
  TextEditingController get speciesController => _speciesController;

  final TextEditingController _move1Controller;
  TextEditingController get move1Controller => _move1Controller;

  final TextEditingController _move2Controller;
  TextEditingController get move2Controller => _move2Controller;

  final TextEditingController _move3Controller;
  TextEditingController get move3Controller => _move3Controller;

  final TextEditingController _move4Controller;
  TextEditingController get move4Controller => _move4Controller;

  void submit() {
    final pokemon = _pokemonDataService.getAllPokemon(generation).where(
      (element) {
        return element.getName() == _speciesController.text;
      },
    ).firstOrNull;

    if (pokemon == null) {
      _snackbarService.showErrorSnackBar(message: l10n.errorNoSpecies);
      return;
    }

    List<Move> moveList = [];

    getMoveFromControllerAndAddToList(TextEditingController controller) {
      final move = _pokemonDataService.getAllMoves(generation.number).where(
        (element) {
          return element.getName() == controller.text;
        },
      ).firstOrNull;
      if (move != null) {
        moveList.add(move);
      }
    }

    getMoveFromControllerAndAddToList(_move1Controller);
    getMoveFromControllerAndAddToList(_move2Controller);
    getMoveFromControllerAndAddToList(_move3Controller);
    getMoveFromControllerAndAddToList(_move4Controller);

    if (moveList.isEmpty) {
      _snackbarService.showErrorSnackBar(message: l10n.errorNoMoves);
      return;
    }

    _routerService.back(
      result: ChoosePokemonDialogResult(
        pokemon: pokemon,
        moves: moveList,
      ),
    );
  }

  void remove() {
    _routerService.back(
      result: ChoosePokemonDialogResult(
        pokemon: null,
        moves: List.empty(),
      ),
    );
  }

  void cancel() {
    _routerService.back();
  }

  List<DropdownMenuEntry<Object?>> buildSpeciesSuggestions(String query) {
    if (query.length < 3) return [];

    return _pokemonDataService.getAllPokemon(generation).where((pokemon) {
      return pokemon.getName().toLowerCase().contains(query.toLowerCase()) && pokemon.id <= generation.pokemonIdUpperBound;
    }).map<DropdownMenuEntry<Pokemon>>((Pokemon pokemon) {
      return DropdownMenuEntry<Pokemon>(
        value: pokemon,
        label: pokemon.getName(),
        leadingIcon: pokemon.getSprite(),
      );
    }).toList();
  }

  List<DropdownMenuEntry<Object?>> buildMoveSuggestions(String query) {
    if (query.length < 3) return [];

    return locator<PokemonDataService>().getAllMoves(generation.number).where(
      (move) {
        return move.getName().toLowerCase().contains(query.toLowerCase());
      },
    ).map<DropdownMenuEntry<Move>>((Move move) {
      return DropdownMenuEntry<Move>(
        value: move,
        label: move.getName(),
        leadingIcon: Container(
          decoration: BoxDecoration(
            color: move.damageClass == 'physical'
                ? const Color.fromARGB(255, 255, 68, 0)
                : move.damageClass == 'special'
                    ? const Color.fromARGB(255, 34, 102, 204)
                    : const Color.fromARGB(255, 131, 131, 131),
            borderRadius: BorderRadius.circular(8),
          ),
          width: 40,
          height: 25,
          child: Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: Image.asset('assets/images/move_classes/${move.damageClass}.png'),
            ),
          ),
        ),
        trailingIcon: Image.asset(
          'assets/images/type_icons/type_${move.type}_$languageCode.png',
          width: 100,
        ),
      );
    }).toList();
  }
}
