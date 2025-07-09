// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get formatButtonLabel => 'Format';

  @override
  String get generateButtonLabel => 'Generate';

  @override
  String get settingButtonLabel => 'Setting';

  @override
  String classNameAssert(Object name) {
    return '$name\'s class name is empty.';
  }

  @override
  String propertyNameAssert(Object name) {
    return '$name: property name is empty';
  }

  @override
  String get formatErrorInfo =>
      'There is something wrong to format. The error has copied into Clipboard.';

  @override
  String get illegalJson => 'Illegal JSON format';

  @override
  String get timeFormatError => 'The format of time is not right.';

  @override
  String get generateSucceed =>
      'The dart code is generated successfully. It has copied into Clipboard.';

  @override
  String get generateFailed =>
      'The dart code is generated failed. The error has copied into Clipboard.';

  @override
  String get inputHelp =>
      'Please input your json string, and click Format button.';

  @override
  String get type => 'Type';

  @override
  String get name => 'Name';

  @override
  String get dataProtection => 'Data Protection';

  @override
  String get arrayProtection => 'Array Protection';

  @override
  String get traverseArrayCount => 'Traverse Array Count';

  @override
  String get nameRule => 'Name Rule';

  @override
  String get original => 'Original';

  @override
  String get camelCase => 'CamelCase';

  @override
  String get pascal => 'Pascal';

  @override
  String get hungarianNotation => 'Hungarian Notation';

  @override
  String get propertyOrder => 'Property Order';

  @override
  String get ascending => 'Ascending';

  @override
  String get descending => 'Descending';

  @override
  String get addMethod => 'Add Protection Method';

  @override
  String get fileHeader => 'File Header';

  @override
  String get fileHeaderHelp =>
      'You can add copyright,dart code, creator into here. support [Date yyyy MM-dd] format to generate time.';

  @override
  String get nullsafety => 'Null Safety';

  @override
  String get nullable => 'Nullable';

  @override
  String get smartNullable => 'Smart Nullable';

  @override
  String get addCopyMethod => 'Add Copy Method';

  @override
  String get duplicateClasses => 'There are duplicate classes';

  @override
  String get warning => 'Warning';

  @override
  String get ok => 'OK';

  @override
  String get propertyCantSameAsClassName =>
      'property can\'t the same as Class name';

  @override
  String keywordCheckFailed(Object name) {
    return '\'$name\' is a key word!';
  }

  @override
  String get propertyCantSameAsType => 'property can\'t the same as Type';

  @override
  String get containsIllegalCharacters => 'contains illegal characters';

  @override
  String get duplicateProperties => 'There are duplicate properties';

  @override
  String get automaticCheck => 'Automatic Check';

  @override
  String get buttonCopyText => 'Copy';

  @override
  String get buttonCopySuccess => 'Copy Success';

  @override
  String get resultDialogTitle => 'Result';

  @override
  String get showResultDialog => 'show result dialog';

  @override
  String get equalityMethodType => 'Equality Method Type';

  @override
  String get none => 'non-generate';

  @override
  String get official => 'official';

  @override
  String get equatable => 'equatable';

  @override
  String get deepCopy => 'deepCopy';
}
