import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/global.dart';
import 'package:pokemate/common/pokemon_data/generation.dart';
import 'package:pokemate/common/pokemon_data/move.dart';
import 'package:pokemate/common/pokemon_data/pokemon.dart';
import 'package:pokemate/common/pokemon_data/pokemon_types.dart';
import 'package:pokemate/common/pokemon_data/team_member.dart';
import 'package:pokemate/services/custom_dialog_service.dart';
import 'package:pokemate/services/custom_snackbar_service.dart';
import 'package:pokemate/services/pokemon_data_service.dart';
import 'package:pokemate/ui/common/persistent_view_model.dart';
import 'package:pokemate/ui/dialogs/choose_pokemon/choose_pokemon_dialog.dart';
import 'package:pokemate/ui/dialogs/choose_pokemon/choose_pokemon_dialog_result.dart';
import 'package:pokemate/ui/dialogs/load_team/load_team_dialog.dart';
import 'package:pokemate/ui/dialogs/login/login_dialog.dart';
import 'package:pokemate/ui/dialogs/save_team/save_team_dialog.dart';

class TeamBuilderViewModel extends PersistentViewModel {
  TeamBuilderViewModel({required super.identifier});

  final _pokemonDataService = locator<PokemonDataService>();
  final _dialogService = locator<CustomDialogService>();
  final _snackbarService = locator<CustomSnackbarService>();

  late Generation _selectedGeneration;
  Generation get selectedGeneration => _selectedGeneration;

  List<TeamMember> _team = [];
  List<TeamMember> get team => _team;

  Map<PokemonType, int> _weaknesses = {};
  Map<PokemonType, int> get weaknesses => _weaknesses;

  List<PokemonType> _offensiveTypes = [];
  List<PokemonType> get offensiveTypes => _offensiveTypes;

  Map<bool, List<Pokemon>> _coveredPokemon = {true: [], false: []};
  Map<bool, List<Pokemon>> get coveredPokemon => _coveredPokemon;

  void initialize() {
    _selectedGeneration = _pokemonDataService.allGenerations.last;
  }

  List<Pokemon> _getPokemonInTeam() {
    List<Pokemon> pokemonInTeam = [];

    for (var member in _team) {
      pokemonInTeam.add(member.species);
    }

    return pokemonInTeam;
  }

  List<PokemonType> _getOffensiveTypes() {
    List<PokemonType> types = [];

    for (var move in _getMovesOfAllTeamMembers()) {
      if (move.damageClass == 'status') continue;

      final type = PokemonType.values.singleWhere(
        (element) {
          return element.name == move.type;
        },
      );

      if (types.contains(type)) continue;
      types.add(type);
    }

    return types;
  }

  Map<PokemonType, int> _calculateDetailedWeaknesses() {
    Map<PokemonType, int> weaknesses = {};

    for (var pokemon in _getPokemonInTeam()) {
      PokemonType type1 = PokemonType.values.singleWhere((element) => element.name == pokemon.firstType);
      PokemonType? type2 = pokemon.secondType == 'none' ? null : PokemonType.values.singleWhere((element) => element.name == pokemon.secondType);

      for (var offensiveType in PokemonType.values) {
        final damageFactor = _pokemonDataService.getDamage(
          offensiveType: offensiveType,
          defensiveType1: type1,
          defensiveType2: type2,
          generation: _selectedGeneration.number,
        );
        if (damageFactor <= 1) continue;

        if (weaknesses.containsKey(offensiveType)) {
          weaknesses[offensiveType] = weaknesses[offensiveType]! + 1;
        } else {
          weaknesses.putIfAbsent(offensiveType, () => 1);
        }
      }
    }

    var sortedEntries = weaknesses.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));
    weaknesses = Map.fromEntries(sortedEntries);

    return weaknesses;
  }

  List<Move> _getMovesOfAllTeamMembers() {
    List<Move> moves = [];

    for (var member in _team) {
      moves.addAll(member.moves);
    }

    return moves;
  }

  Map<bool, List<Pokemon>> _getOffensivelyCoveredPokemon() {
    Map<bool, List<Pokemon>> coverageMap = {true: [], false: []};

    final offensiveTypes = _getOffensiveTypes();

    for (var pokemon in _pokemonDataService.getAllPokemon(_selectedGeneration)) {
      PokemonType type1 = PokemonType.values.singleWhere((element) => element.name == pokemon.firstType);
      PokemonType? type2 = pokemon.secondType == 'none' ? null : PokemonType.values.singleWhere((element) => element.name == pokemon.secondType);
      var covered = false;

      for (var offensiveType in offensiveTypes) {
        final damage = _pokemonDataService.getDamage(
          offensiveType: offensiveType,
          defensiveType1: type1,
          defensiveType2: type2,
          generation: _selectedGeneration.number,
        );
        if (damage <= 1) continue;

        covered = true;
        break;
      }

      coverageMap[covered]!.add(pokemon);
    }

    return coverageMap;
  }

  _calculateWeaknessesAndCoverage() {
    _weaknesses = _calculateDetailedWeaknesses();
    _offensiveTypes = _getOffensiveTypes();
    _coveredPokemon = _getOffensivelyCoveredPokemon();
  }

  _updateTeamForGeneration() {
    for (var memberIdx = _team.length - 1; memberIdx >= 0; memberIdx--) {
      final member = _team[memberIdx];

      final speciesNotInThisGeneration = member.species.id > _selectedGeneration.pokemonIdUpperBound;
      final alternativeFormNotInThisGeneration = member.species.alternativeForm != null && member.species.alternativeForm!.sinceGeneration > _selectedGeneration.number;
      if (speciesNotInThisGeneration || alternativeFormNotInThisGeneration) {
        _team.removeAt(memberIdx);
        continue;
      }

      if (member.species.changes != null) {
        final newPokemon = _pokemonDataService.getAllPokemon(_selectedGeneration).singleWhere((element) => element.nameEnglish == member.species.nameEnglish);
        _team[memberIdx] = TeamMember(species: newPokemon, moves: member.moves);
      }

      for (var moveIdx = member.moves.length - 1; moveIdx >= 0; moveIdx--) {
        final move = member.moves[moveIdx];
        if (_selectedGeneration.number < move.sinceGeneration) {
          member.moves.removeAt(moveIdx);
        } else if (move.changes != null) {
          member.moves[moveIdx] = _pokemonDataService.getAllMoves(_selectedGeneration.number).singleWhere((element) => element.nameEnglish == move.nameEnglish);
        }
      }
    }
  }

  void onSelectGeneration(Generation? generation) {
    if (generation == null) return;

    _selectedGeneration = generation;
    _updateTeamForGeneration();
    _calculateWeaknessesAndCoverage();
    rebuildUi();
  }

  void clearTeam() {
    _team.clear();
    _calculateWeaknessesAndCoverage();
    rebuildUi();
  }

  void saveTeam() async {
    if (_team.isEmpty) {
      _snackbarService.showErrorSnackBar(message: l10n.errorNoPokemon);
      return;
    }

    final jwt = prefs.getString('jwt');
    if (jwt == null) {
      final result = await _dialogService.showDialog(builder: (context) => const LoginDialog());

      if (result != true) return;
    }

    _dialogService.showDialog(
      builder: (context) {
        return SaveTeamDialog(
          generation: _selectedGeneration.number,
          team: _team,
        );
      },
    );
  }

  void loadTeam() async {
    final jwt = prefs.getString('jwt');
    if (jwt == null) {
      final result = await _dialogService.showDialog(
        builder: (context) => const LoginDialog(),
      );

      if (result != true) return;
    }

    _dialogService.showDialog(
      builder: (context) {
        return LoadTeamDialog(
          onLoad: (team, generation) {
            _snackbarService.showSuccessSnackBar(message: l10n.successLoadTeam);
            _team = team;
            _selectedGeneration = _pokemonDataService.allGenerations.singleWhere((gen) => gen.number == generation);
            _updateTeamForGeneration();
            _calculateWeaknessesAndCoverage();
            rebuildUi();
          },
        );
      },
    );
  }

  void showPokemonChooseDialog({required int teamIndex}) async {
    final member = team.elementAtOrNull(teamIndex);

    final result = await _dialogService.showDialog(
      builder: (_) {
        return ChoosePokemonDialog(
          generation: selectedGeneration,
          species: member?.species.getName(),
          move1: member?.moves.elementAtOrNull(0)?.getName(),
          move2: member?.moves.elementAtOrNull(1)?.getName(),
          move3: member?.moves.elementAtOrNull(2)?.getName(),
          move4: member?.moves.elementAtOrNull(3)?.getName(),
        );
      },
    ) as ChoosePokemonDialogResult?;

    if (result == null) return;

    if (result.pokemon == null) {
      onRemovePokemonFromTeam(index: teamIndex);
    } else {
      onChoosePokemonForTeam(
        index: teamIndex,
        pokemon: result.pokemon!,
        moves: result.moves,
      );
    }
  }

  void onChoosePokemonForTeam({
    required int index,
    required Pokemon pokemon,
    required List<Move> moves,
  }) {
    List<TeamMember> newTeam = team;
    final newMember = TeamMember(species: pokemon, moves: moves);
    if (newTeam.length < index + 1) {
      newTeam.add(newMember);
    } else {
      newTeam[index] = newMember;
    }
    _updateTeam(newTeam);
  }

  void onRemovePokemonFromTeam({
    required int index,
  }) {
    List<TeamMember> newTeam = team;
    if (newTeam.length < index + 1) return;
    newTeam.removeAt(index);
    _updateTeam(newTeam);
  }

  void _updateTeam(List<TeamMember> team) {
    _team = team;
    _calculateWeaknessesAndCoverage();
    rebuildUi();
  }
}
