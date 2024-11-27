import 'package:flutter/material.dart';
import 'package:pokemate/ui/views/team_builder/team_builder_viewmodel.dart';
import 'package:pokemate/ui/widgets/team_builder/team_slot/team_slot.dart';
import 'package:stacked/stacked.dart';

class TeamSlots extends ViewModelWidget<TeamBuilderViewModel> {
  const TeamSlots({super.key});

  @override
  Widget build(BuildContext context, TeamBuilderViewModel viewModel) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TeamSlot(index: 0),
            SizedBox(width: 16),
            TeamSlot(index: 1),
            SizedBox(width: 16),
            TeamSlot(index: 2),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TeamSlot(index: 3),
            SizedBox(width: 16),
            TeamSlot(index: 4),
            SizedBox(width: 16),
            TeamSlot(index: 5),
          ],
        ),
      ],
    );
  }
}
