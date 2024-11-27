import 'package:pokemate/common/pokemon_data/move.dart';
import 'package:pokemate/common/pokemon_data/pokemon.dart';

class ChoosePokemonDialogResult {
  final Pokemon? pokemon;
  final List<Move> moves;

  ChoosePokemonDialogResult({
    required this.pokemon,
    required this.moves,
  });
}
