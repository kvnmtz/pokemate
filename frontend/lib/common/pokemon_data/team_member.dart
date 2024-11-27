import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/common/pokemon_data/move.dart';
import 'package:pokemate/common/pokemon_data/pokemon.dart';
import 'package:pokemate/services/pokemon_data_service.dart';

class TeamMember {
  final Pokemon species;
  final List<Move> moves;

  TeamMember({
    required this.species,
    required this.moves,
  });

  static final _pokemonDataService = locator<PokemonDataService>();

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      species: _pokemonDataService.allPokemon.singleWhere((pokemon) => pokemon.getName() == json['species']),
      moves: List<String>.from(json['moves']).map((moveName) {
        return _pokemonDataService.allMoves.singleWhere((move) => move.getName() == moveName);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'species': species.getName(),
      'moves': moves.map((move) => move.getName()).toList(),
    };
  }

  static List<Map<String, dynamic>> convertListToJson(List<TeamMember> team) {
    return team.map((member) => member.toJson()).toList();
  }
}
