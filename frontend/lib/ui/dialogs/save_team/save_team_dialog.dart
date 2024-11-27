import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/common/pokemon_data/team_member.dart';
import 'package:stacked/stacked.dart';

import 'save_team_dialog_model.dart';

class SaveTeamDialog extends StackedView<SaveTeamDialogModel> {
  final int generation;
  final List<TeamMember> team;

  const SaveTeamDialog({
    super.key,
    required this.generation,
    required this.team,
  });

  @override
  Widget builder(BuildContext context, SaveTeamDialogModel viewModel, Widget? child) {
    return LayoutBuilder(builder: (context, _) {
      final screenWidth = context.mediaQuery.size.width;
      var dialogWidth = screenWidth;

      if (dialogWidth > 700) {
        dialogWidth = 700;
      }

      return Dialog(
        child: SizedBox(
          width: dialogWidth,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.t.giveTeamName,
                    style: context.theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: viewModel.nameController,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: context.t.name,
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.tonal(
                    onPressed: viewModel.save,
                    child: Text(context.t.save),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  SaveTeamDialogModel viewModelBuilder(BuildContext context) {
    return SaveTeamDialogModel(
      generation: generation,
      team: team,
    );
  }
}
