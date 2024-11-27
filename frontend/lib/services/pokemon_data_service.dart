import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/global.dart';
import 'package:pokemate/common/pokemon_data/generation.dart';
import 'package:pokemate/common/pokemon_data/move.dart';
import 'package:pokemate/common/pokemon_data/pokemon.dart';
import 'package:pokemate/common/pokemon_data/pokemon_types.dart';
import 'package:pokemate/services/backend_api_service.dart';
import 'package:pokemate/services/custom_snackbar_service.dart';

class PokemonDataService {
  List<Generation> allGenerations = [];

  List<Pokemon> allPokemon = [];
  final Map<int, List<Pokemon>> _allPokemonForGenerationCache = {};

  List<Pokemon> getAllPokemon(Generation generation) {
    if (_allPokemonForGenerationCache.containsKey(generation.number)) {
      return _allPokemonForGenerationCache[generation.number]!;
    }

    List<Pokemon> allPokemonForGeneration = [];

    for (var pokemon in allPokemon) {
      if (pokemon.id > generation.pokemonIdUpperBound) continue;

      if (pokemon.alternativeForm != null) {
        if (generation.number < pokemon.alternativeForm!.sinceGeneration) continue;
      }

      if (pokemon.changes != null) {
        int matchingIdx = -1;
        for (var i = 0; i < pokemon.changes!.length; i++) {
          final change = pokemon.changes![i];
          if (generation.number < change.priorToGeneration) {
            if (matchingIdx == -1 || change.priorToGeneration < pokemon.changes![matchingIdx].priorToGeneration) {
              matchingIdx = i;
            }
          }
        }
        if (matchingIdx != -1) {
          final matchingChange = pokemon.changes![matchingIdx];
          allPokemonForGeneration.add(Pokemon(
            id: pokemon.id,
            alternativeForm: pokemon.alternativeForm,
            nameEnglish: pokemon.nameEnglish,
            nameGerman: pokemon.nameGerman,
            firstType: matchingChange.firstType,
            secondType: matchingChange.secondType,
            changes: pokemon.changes,
          ));
        } else {
          allPokemonForGeneration.add(pokemon);
        }
      } else {
        allPokemonForGeneration.add(pokemon);
      }
    }

    _allPokemonForGenerationCache.putIfAbsent(generation.number, () => allPokemonForGeneration);

    return allPokemonForGeneration;
  }

  List<Move> allMoves = [];
  final Map<int, List<Move>> _allMovesForGenerationCache = {};

  List<Move> getAllMoves(int generation) {
    if (_allMovesForGenerationCache.containsKey(generation)) {
      return _allMovesForGenerationCache[generation]!;
    }

    List<Move> allMovesForGeneration = [];

    for (var move in allMoves) {
      if (move.sinceGeneration > generation) continue;

      if (move.changes != null) {
        int matchingIdx = -1;
        for (var i = 0; i < move.changes!.length; i++) {
          final change = move.changes![i];
          if (generation < change.priorToGeneration) {
            if (matchingIdx == -1 || change.priorToGeneration < move.changes![matchingIdx].priorToGeneration) {
              matchingIdx = i;
            }
          }
        }
        if (matchingIdx != -1) {
          final changedType = move.changes![matchingIdx].type;
          allMovesForGeneration.add(Move(
            sinceGeneration: move.sinceGeneration,
            nameEnglish: move.nameEnglish,
            nameGerman: move.nameGerman,
            damageClass: move.damageClass,
            changes: move.changes,
            type: changedType,
          ));
        } else {
          allMovesForGeneration.add(move);
        }
      } else {
        allMovesForGeneration.add(move);
      }
    }

    _allMovesForGenerationCache.putIfAbsent(generation, () => allMovesForGeneration);

    return allMovesForGeneration;
  }

  final _snackbarService = locator<CustomSnackbarService>();

  Future<Map<String, dynamic>?> _fetchData({
    bool retry = false,
  }) async {
    final result = await locator<BackendApiService>().getPokemonData();
    if (!result.isSuccessful) {
      if (!kIsWeb) {
        if (!prefs.containsKey('pokemon_data')) return null;
        return jsonDecode(prefs.getString('pokemon_data')!);
      } else {
        if (retry) {
          _snackbarService.showDetailedErrorSnackBar(
            message: l10n.errorWhileInitializing,
            detailedMessage: result.errorMessage,
          );
        }
        return null;
      }
    }

    if (!kIsWeb) {
      prefs.setString('pokemon_data', jsonEncode(result.data));
    }

    return result.data;
  }

  bool _parseData(Map<String, dynamic> json) {
    try {
      allPokemon = (json['pokemon'] as List).map((pokemon) => Pokemon.fromJson(pokemon)).toList();
      allGenerations = (json['generations'] as List).map((generation) => Generation.fromJson(generation)).toList();
      allMoves = (json['moves'] as List).map((move) => Move.fromJson(move)).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> initialize({
    bool retry = false,
  }) async {
    final data = await _fetchData(retry: retry);
    if (data == null) return false;

    return _parseData(data);
  }

  double _getDamageSingleType({
    required PokemonType offensiveType,
    required PokemonType defensiveType,
    required int generation,
  }) {
    if (generation == 1) {
      return effectivitiesGen1[offensiveType.index][defensiveType.index];
    } else if (generation < 6) {
      return effectivitiesGen2To5[offensiveType.index][defensiveType.index];
    } else {
      return effectivitiesGen6To9[offensiveType.index][defensiveType.index];
    }
  }

  double getDamage({
    required PokemonType offensiveType,
    required PokemonType defensiveType1,
    required PokemonType? defensiveType2,
    required int generation,
  }) {
    if (defensiveType2 == null) {
      return _getDamageSingleType(
        offensiveType: offensiveType,
        defensiveType: defensiveType1,
        generation: generation,
      );
    }

    final damage1 = _getDamageSingleType(
      offensiveType: offensiveType,
      defensiveType: defensiveType1,
      generation: generation,
    );
    final damage2 = _getDamageSingleType(
      offensiveType: offensiveType,
      defensiveType: defensiveType2,
      generation: generation,
    );
    return damage1 * damage2;
  }

  bool isTypeInvalidForGeneration({
    required PokemonType type,
    required Generation generation,
  }) {
    return ((type == PokemonType.dark || type == PokemonType.steel) && generation.number == 1 || (type == PokemonType.fairy && generation.number < 6));
  }
}
