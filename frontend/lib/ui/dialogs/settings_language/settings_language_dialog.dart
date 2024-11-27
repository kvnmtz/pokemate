import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:pokemate/extensions/build_context_extensions.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'settings_language_dialog_model.dart';

class SettingsLanguageDialog extends StackedView<SettingsLanguageDialogModel> {
  const SettingsLanguageDialog({super.key});

  @override
  Widget builder(BuildContext context, SettingsLanguageDialogModel viewModel, Widget? child) {
    return AlertDialog(
      title: Text(context.t.language),
      icon: const Icon(Icons.language),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            AppLocalizations.supportedLocales.length,
            (index) {
              final locale = AppLocalizations.supportedLocales.elementAt(index);
              return RadioListTile(
                title: Text(LocaleNamesLocalizationsDelegate.nativeLocaleNames[locale.languageCode]!),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                value: locale,
                groupValue: viewModel.locale,
                onChanged: (value) => viewModel.setLocale(value!),
              );
            },
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: viewModel.closeDialog,
          child: Text(context.t.ok),
        ),
      ],
    );
  }

  @override
  SettingsLanguageDialogModel viewModelBuilder(BuildContext context) => SettingsLanguageDialogModel();
}
