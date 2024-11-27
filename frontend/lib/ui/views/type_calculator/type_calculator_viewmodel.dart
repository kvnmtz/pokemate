import 'package:flutter/material.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/common/pokemon_data/generation.dart';
import 'package:pokemate/common/pokemon_data/pokemon.dart';
import 'package:pokemate/common/pokemon_data/pokemon_types.dart';
import 'package:pokemate/services/pokemon_data_service.dart';
import 'package:pokemate/services/settings_service.dart';
import 'package:pokemate/ui/common/persistent_view_model.dart';

class TypeCalculatorViewModel extends PersistentViewModel {
  TypeCalculatorViewModel({required super.identifier});

  final _pokemonDataService = locator<PokemonDataService>();
  final _settingsService = locator<SettingsService>();

  PokemonType _firstType = PokemonType.normal;
  PokemonType get firstType => _firstType;

  void _setFirstType(PokemonType type) {
    _firstType = type;
    if (_secondType == type) {
      _secondType = null;
    }
    rebuildUi();
  }

  PokemonType? _secondType;
  PokemonType? get secondType => _secondType;

  void _setSecondType(PokemonType? type) {
    _secondType = type;
    rebuildUi();
  }

  late Generation _selectedGeneration;
  Generation get selectedGeneration => _selectedGeneration;

  void setSelectedGeneration(Generation generation) {
    _selectedGeneration = generation;
    rebuildUi();
  }

  void initialize() {
    _selectedGeneration = _pokemonDataService.allGenerations.last;
    _calculateDamageFactors();
  }

  final _damageFactors = <double, List<PokemonType>>{
    4.0: [],
    2.0: [],
    1.0: [],
    0.5: [],
    0.25: [],
    0.0: [],
  };
  Map<double, List<PokemonType>> get damageFactors => _damageFactors;

  final _searchController = SearchController();
  SearchController get searchController => _searchController;

  List<Pokemon> _searchResults = [];
  List<Pokemon> get searchResults => _searchResults;

  void searchPokemon(String query, BuildContext context) {
    if (query.length >= 3) {
      _searchResults = _pokemonDataService.getAllPokemon(selectedGeneration).where(
        (pokemon) {
          final lowerQuery = query.toLowerCase();
          if (_settingsService.multiLanguageSearch) {
            return pokemon.nameEnglish.toLowerCase().contains(lowerQuery) || pokemon.nameGerman.toLowerCase().contains(lowerQuery);
          } else {
            return pokemon.getName().toLowerCase().contains(lowerQuery);
          }
        },
      ).toList();
    } else {
      _searchResults = [];
    }
    rebuildUi();
  }

  void onSearchResultTap({
    required Pokemon pokemon,
    required BuildContext context,
  }) {
    _searchController.closeView(pokemon.getName());
    rebuildUi();
    onSelectPokemon(pokemon);
  }

  void onSelectPokemon(Pokemon pokemon) {
    _setFirstType(PokemonType.values.firstWhere(
      (type) {
        return type.name == pokemon.firstType;
      },
    ));

    if (pokemon.secondType == 'none') {
      _setSecondType(null);
    } else {
      _setSecondType(PokemonType.values.firstWhere(
        (type) {
          return type.name == pokemon.secondType;
        },
      ));
    }

    _calculateDamageFactors();

    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void _calculateDamageFactors() {
    _damageFactors[4.0] = [];
    _damageFactors[2.0] = [];
    _damageFactors[1.0] = [];
    _damageFactors[0.5] = [];
    _damageFactors[0.25] = [];
    _damageFactors[0.0] = [];

    for (var type in PokemonType.values) {
      var damageFactor = _pokemonDataService.getDamage(
        offensiveType: type,
        defensiveType1: _firstType,
        defensiveType2: _secondType,
        generation: _selectedGeneration.number,
      );
      var isTypeValidForSelectedGeneration = _damageFactors[damageFactor] != null;
      if (isTypeValidForSelectedGeneration) {
        _damageFactors[damageFactor]!.add(type);
      }
    }
  }

  void onSelectGeneration(Generation? generation) {
    if (generation == null) return;
    setSelectedGeneration(generation);

    // Check for illegally selected types
    if (_selectedGeneration.number < 6) {
      if (_firstType.name == 'fairy') {
        _setFirstType(PokemonType.normal);
      }
      if (_secondType != null && _secondType!.name == 'fairy') {
        _setSecondType(null);
      }
    }
    if (_selectedGeneration.number == 1) {
      if (_firstType.name == 'dark' || _firstType.name == 'steel') {
        _setFirstType(PokemonType.normal);
      }
      if (_secondType != null && (_secondType!.name == 'dark' || _secondType!.name == 'steel')) {
        _setSecondType(null);
      }
    }

    _calculateDamageFactors();
  }

  void onSelectFirstType(PokemonType type) {
    _setFirstType(type);
    _calculateDamageFactors();
  }

  void onSelectSecondType(PokemonType? type) {
    _setSecondType(type);
    _calculateDamageFactors();
  }
}
