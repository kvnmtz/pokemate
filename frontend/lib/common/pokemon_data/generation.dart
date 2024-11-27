import 'package:pokemate/global.dart';

class Generation {
  final int number;
  final String examplesEnglish;
  final String examplesGerman;
  final int pokemonIdUpperBound;

  Generation({
    required this.number,
    required this.examplesEnglish,
    required this.examplesGerman,
    required this.pokemonIdUpperBound,
  });

  String getExamples() {
    switch (languageCode) {
      case 'de':
        return examplesGerman;
      case 'en':
      default:
        return examplesEnglish;
    }
  }

  factory Generation.fromJson(Map<String, dynamic> json) {
    return Generation(
      number: json['number'],
      examplesEnglish: json['examples_en'],
      examplesGerman: json['examples_de'],
      pokemonIdUpperBound: json['pokemon_id_upper_bound'],
    );
  }
}
