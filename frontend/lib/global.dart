import 'package:flutter/material.dart';
import 'package:pokemate/app/app.router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/* Global access to localizations - will not trigger a rebuild though, use context.t for that */
AppLocalizations get l10n => AppLocalizations.of(stackedRouter.navigatorKey.currentContext!)!;
String get languageCode => Localizations.localeOf(stackedRouter.navigatorKey.currentContext!).languageCode;

late SharedPreferences prefs;
