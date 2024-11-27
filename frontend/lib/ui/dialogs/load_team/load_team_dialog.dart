import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/common/pokemon_data/team_member.dart';
import 'package:pokemate/ui/widgets/load_team_dialog/team_card/team_card.dart';
import 'package:stacked/stacked.dart';

import 'load_team_dialog_model.dart';

class LoadTeamDialog extends StackedView<LoadTeamDialogModel> {
  final void Function(List<TeamMember> team, int generation) onLoad;

  const LoadTeamDialog({
    super.key,
    required this.onLoad,
  });

  @override
  void onViewModelReady(LoadTeamDialogModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.initialize();
  }

  @override
  Widget builder(BuildContext context, LoadTeamDialogModel viewModel, Widget? child) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.t.savedTeams),
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (viewModel.teams != null && viewModel.teams!.isNotEmpty)
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          viewModel.teams!.length,
                          (idx) {
                            final team = viewModel.teams![idx];
                            return TeamCard(
                              team: team,
                              index: idx,
                              onLoad: onLoad,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: viewModel.teams == null
                      ? const CircularProgressIndicator()
                      : viewModel.teams!.isEmpty
                          ? Text(context.t.noSavedTeams)
                          : const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  LoadTeamDialogModel viewModelBuilder(BuildContext context) => LoadTeamDialogModel();
}
