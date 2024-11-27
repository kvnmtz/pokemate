import 'package:flutter/material.dart';
import 'package:pokemate/ui/views/team_builder/team_builder_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TeamSlot extends ViewModelWidget<TeamBuilderViewModel> {
  final int index;

  const TeamSlot({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context, TeamBuilderViewModel viewModel) {
    final member = viewModel.team.elementAtOrNull(index);
    final doesPreviousTeamMemberExist = index == 0 || viewModel.team.elementAtOrNull(index - 1) != null;
    return IconButton.filledTonal(
      onPressed: doesPreviousTeamMemberExist ? () => viewModel.showPokemonChooseDialog(teamIndex: index) : null,
      icon: member == null
          ? const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.add),
            )
          : IgnorePointer(
              child: member.species.getSprite(),
            ),
    );
  }
}
