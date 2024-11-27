import 'package:flutter/material.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/ui/common/persistent_view.dart';
import 'package:pokemate/ui/widgets/team_builder/team_slots/team_slots.dart';
import 'package:pokemate/ui/widgets/common/generation_picker/generation_picker.dart';

import 'team_builder_viewmodel.dart';

class TeamBuilderView extends PersistentView<TeamBuilderViewModel> {
  const TeamBuilderView({super.key});

  @override
  void onViewModelReady(TeamBuilderViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.initialize();
  }

  @override
  Widget builder(BuildContext context, TeamBuilderViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Scrollbar(
        interactive: true,
        controller: viewModel.scrollController,
        radius: context.theme.platform == TargetPlatform.android ? const Radius.circular(2) : null,
        child: CustomScrollView(
          controller: viewModel.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    GenerationPicker(
                      selectedGeneration: viewModel.selectedGeneration,
                      onSelected: viewModel.onSelectGeneration,
                    ),
                    const SizedBox(height: 32),
                    const TeamSlots(),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: () {
                            context.focusScope.unfocus();
                            viewModel.loadTeam();
                          },
                          label: Text(context.t.load),
                          icon: const Icon(Icons.file_open),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: viewModel.saveTeam,
                          label: Text(context.t.save),
                          icon: const Icon(Icons.save),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: viewModel.clearTeam,
                          label: Text(context.t.clear),
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      context.t.weaknesses,
                      style: context.theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (viewModel.weaknesses.isEmpty)
                      Text(
                        context.t.weaknessesNone,
                        textAlign: TextAlign.center,
                      )
                    else
                      Column(
                        children: List.generate(
                          viewModel.weaknesses.keys.length,
                          (idx) {
                            final type = viewModel.weaknesses.keys.elementAt(idx);
                            final isLastElement = idx == viewModel.weaknesses.keys.length - 1;
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${viewModel.weaknesses[type].toString()}\u00D7'),
                                    const SizedBox(width: 8),
                                    Image.asset(
                                      'assets/images/type_icons/type_${type.name}_${context.locale.languageCode}.png',
                                      width: 100,
                                    ),
                                  ],
                                ),
                                if (!isLastElement) const SizedBox(height: 8),
                              ],
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 32),
                    Text(
                      context.t.offensiveCoverage,
                      style: context.theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (viewModel.offensiveTypes.isNotEmpty)
                      Column(
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: List.generate(
                              viewModel.offensiveTypes.length,
                              (idx) {
                                return Image.asset(
                                  'assets/images/type_icons/type_${viewModel.offensiveTypes[idx].name}_${context.locale.languageCode}.png',
                                  width: 100,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    if (viewModel.coveredPokemon[true]!.isEmpty)
                      Text(
                        context.t.teamCantHitAnything,
                        textAlign: TextAlign.center,
                      )
                    else
                      Column(
                        children: [
                          Text(
                            context.t.teamHitsXSuperEffectively(viewModel.coveredPokemon[true]!.length, viewModel.coveredPokemon[true]!.length + viewModel.coveredPokemon[false]!.length),
                            textAlign: TextAlign.center,
                          ),
                          if (viewModel.coveredPokemon[false]!.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  context.t.notCoveredPokemon,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                    viewModel.coveredPokemon[false]!.length,
                                    (idx) {
                                      final pokemon = viewModel.coveredPokemon[false]![idx];
                                      return Tooltip(
                                        richMessage: WidgetSpan(
                                          child: Builder(builder: (context) {
                                            final isDarkTheme = context.theme.brightness == Brightness.dark;

                                            return Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    pokemon.getName(),
                                                    style: TextStyle(
                                                      color: isDarkTheme ? Colors.black : Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/type_icons/type_${pokemon.firstType}_${context.locale.languageCode}.png',
                                                        width: 100,
                                                      ),
                                                      if (pokemon.secondType != 'none')
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            const SizedBox(width: 8),
                                                            Image.asset(
                                                              'assets/images/type_icons/type_${pokemon.secondType}_${context.locale.languageCode}.png',
                                                              width: 100,
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                        child: SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: pokemon.getSprite(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  String get identifier => 'team_builder';

  @override
  TeamBuilderViewModel initialViewModelBuilder(BuildContext context, String identifier) => TeamBuilderViewModel(identifier: identifier);
}
