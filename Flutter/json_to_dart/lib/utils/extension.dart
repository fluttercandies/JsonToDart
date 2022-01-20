import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

extension StringE on String {
  String get uid => this + '${DateTime.now().microsecondsSinceEpoch}';
}

AppLocalizations get appLocalizations => AppLocalizations.of(Get.context!)!;
