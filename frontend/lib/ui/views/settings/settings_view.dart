import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:pokemate/app/app.locator.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:pokemate/services/pokemon_data_service.dart';
import 'package:pokemate/ui/common/persistent_view.dart';

import 'settings_viewmodel.dart';

class SettingsView extends PersistentView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget builder(BuildContext context, SettingsViewModel viewModel, Widget? child) {
    final pokemonDataService = locator<PokemonDataService>();
    return Scaffold(
      body: Scrollbar(
        interactive: true,
        controller: viewModel.scrollController,
        radius: context.theme.platform == TargetPlatform.android ? const Radius.circular(2) : null,
        child: CustomScrollView(
          controller: viewModel.scrollController,
          slivers: [
            SliverAppBar(
              title: Text(context.t.settings),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    title: Text(context.t.darkTheme),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        pokemonDataService.allPokemon.singleWhere((pokemon) => pokemon.id == 338).getSprite(),
                        const SizedBox(width: 8),
                        IgnorePointer(
                          child: Switch(
                            value: viewModel.darkMode,
                            onChanged: (value) {}, // onTap of ListTile handles this
                          ),
                        ),
                        const SizedBox(width: 8),
                        pokemonDataService.allPokemon.singleWhere((pokemon) => pokemon.id == 337).getSprite(),
                      ],
                    ),
                    onTap: viewModel.toggleDarkMode,
                  ),
                  const Divider(height: 0),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    title: Text(context.t.language),
                    subtitle: Text(LocaleNamesLocalizationsDelegate.nativeLocaleNames[viewModel.locale.languageCode]!),
                    onTap: viewModel.showLanguageDialog,
                  ),
                  const Divider(height: 0),
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    title: Text(context.t.multiLanguageSearch),
                    subtitle: Text(context.t.multiLanguageSearchDesc),
                    value: viewModel.multiLanguageSearch,
                    onChanged: (value) => viewModel.toggleMultiLanguageSearch(),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    title: Text(context.t.logout),
                    onTap: viewModel.logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  String get identifier => 'settings';

  @override
  SettingsViewModel initialViewModelBuilder(BuildContext context, String identifier) => SettingsViewModel(identifier: identifier);
}
