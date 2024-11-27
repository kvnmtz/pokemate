import 'package:flutter/material.dart';
import 'package:pokemate/common/pokemon_data/team_member.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/ui/dialogs/load_team/load_team_dialog_model.dart';
import 'package:stacked/stacked.dart';

class TeamCard extends ViewModelWidget<LoadTeamDialogModel> {
  final Team team;
  final int index;
  final void Function(List<TeamMember> team, int generation) onLoad;

  const TeamCard({
    super.key,
    required this.team,
    required this.index,
    required this.onLoad,
  });

  @override
  Widget build(BuildContext context, LoadTeamDialogModel viewModel) {
    return Card.filled(
      child: SizedBox(
        width: 320,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(team.name),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 0,
                runSpacing: 8,
                children: team.team.length > 3
                    ? [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            3,
                            (memberIdx) {
                              return team.team[memberIdx].species.getSprite();
                            },
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            team.team.length - 3,
                            (memberIdx) {
                              return team.team[memberIdx + 3].species.getSprite();
                            },
                          ),
                        ),
                      ]
                    : List.generate(
                        team.team.length,
                        (memberIdx) {
                          return team.team[memberIdx].species.getSprite();
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () {
                      onLoad(team.team, team.generation);
                      context.nav.pop();
                    },
                    label: Text(context.t.load),
                    icon: const Icon(Icons.file_open),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () => viewModel.deleteTeam(index: index),
                    label: Text(context.t.delete),
                    icon: const Icon(Icons.delete_forever),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
