import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'navigator/navigator.dart';

// ignore: avoid_classes_with_only_static_members
class I18n {
  static List<Locale> supportedLocales = AppLocalizations.supportedLocales;

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context)!;
  }

  static AppLocalizations get instance => Localizations.of<AppLocalizations>(
      AppNavigator().context, AppLocalizations)!;
}
