import 'package:flutter/material.dart';
import 'package:pokemate/app/app.router.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/global.dart';

class PokemonChange {
  final int priorToGeneration;
  final String firstType;
  final String secondType;

  PokemonChange({
    required this.priorToGeneration,
    required this.firstType,
    required this.secondType,
  });

  factory PokemonChange.fromJson(Map<String, dynamic> json) {
    return PokemonChange(
      priorToGeneration: json['prior_to_generation'],
      firstType: json['type1'],
      secondType: json['type2'],
    );
  }
}

class PokemonAlternativeForm {
  final int id;
  final int sinceGeneration;

  PokemonAlternativeForm({
    required this.id,
    required this.sinceGeneration,
  });

  factory PokemonAlternativeForm.fromJson(Map<String, dynamic> json) {
    return PokemonAlternativeForm(
      id: json['id'],
      sinceGeneration: json['since_generation'],
    );
  }
}

class Pokemon {
  final int id;
  final PokemonAlternativeForm? alternativeForm;
  final String nameEnglish;
  final String nameGerman;
  final String firstType;
  final String secondType;
  final List<PokemonChange>? changes;

  Pokemon({
    required this.id,
    this.alternativeForm,
    required this.nameEnglish,
    required this.nameGerman,
    required this.firstType,
    required this.secondType,
    this.changes,
  });

  String getName() {
    switch (languageCode) {
      case 'de':
        return nameGerman;
      case 'en':
      default:
        return nameEnglish;
    }
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      alternativeForm: json.containsKey('alternative_form') ? PokemonAlternativeForm.fromJson(json['alternative_form']) : null,
      nameEnglish: json['name_en'],
      nameGerman: json['name_de'],
      firstType: json['type1'],
      secondType: json['type2'],
      changes: json['changes'] != null ? (json['changes'] as List).map((changeJson) => PokemonChange.fromJson(changeJson)).toList() : null,
    );
  }

  String _getSpritePath({required bool large}) {
    return 'assets/images/pokemon_icons/${large ? 'large' : 'small'}/${id.toString().padLeft(4, '0')}${alternativeForm != null ? '_${alternativeForm!.id.toString().padLeft(2, '0')}' : ''}.png';
  }

  Image getSprite() {
    final dpi = stackedRouter.navigatorKey.currentContext!.mediaQuery.devicePixelRatio;

    if (dpi <= 1) {
      return Image.asset(
        _getSpritePath(large: false),
        height: 40,
        width: 40,
        filterQuality: FilterQuality.none,
      );
    } else {
      return Image.asset(
        _getSpritePath(large: true),
        height: 40,
        width: 40,
      );
    }
  }
}
