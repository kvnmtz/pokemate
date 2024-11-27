import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextExtensions on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this)!;
  ThemeData get theme => Theme.of(this);
  NavigatorState get nav => Navigator.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  PageStorageBucket get pageStorage => PageStorage.of(this);
  FocusScopeNode get focusScope => FocusScope.of(this);
  Locale get locale => Localizations.localeOf(this);
}
