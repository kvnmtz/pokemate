import 'package:pokemate/global.dart';

class MoveChange {
  final int priorToGeneration;
  final String type;

  MoveChange({
    required this.priorToGeneration,
    required this.type,
  });

  factory MoveChange.fromJson(Map<String, dynamic> json) {
    return MoveChange(
      priorToGeneration: json['prior_to_generation'],
      type: json['type'],
    );
  }
}

class Move {
  final int sinceGeneration;
  final String nameEnglish;
  final String nameGerman;
  final String damageClass;
  final String type;
  final List<MoveChange>? changes;

  Move({
    required this.sinceGeneration,
    required this.nameEnglish,
    required this.nameGerman,
    required this.damageClass,
    required this.type,
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

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      sinceGeneration: json['since_generation'],
      nameEnglish: json['name_en'],
      nameGerman: json['name_de'],
      damageClass: json['class'],
      type: json['type'],
      changes: json['changes'] != null ? (json['changes'] as List).map((changeJson) => MoveChange.fromJson(changeJson)).toList() : null,
    );
  }
}
