import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @formatButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get formatButtonLabel;

  /// No description provided for @generateButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generateButtonLabel;

  /// No description provided for @settingButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get settingButtonLabel;

  /// No description provided for @classNameAssert.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s class name is empty.'**
  String classNameAssert(Object name);

  /// No description provided for @propertyNameAssert.
  ///
  /// In en, this message translates to:
  /// **'{name}: property name is empty'**
  String propertyNameAssert(Object name);

  /// No description provided for @formatErrorInfo.
  ///
  /// In en, this message translates to:
  /// **'There is something wrong to format. The error has copied into Clipboard.'**
  String get formatErrorInfo;

  /// No description provided for @illegalJson.
  ///
  /// In en, this message translates to:
  /// **'Illegal JSON format'**
  String get illegalJson;

  /// No description provided for @timeFormatError.
  ///
  /// In en, this message translates to:
  /// **'The format of time is not right.'**
  String get timeFormatError;

  /// No description provided for @generateSucceed.
  ///
  /// In en, this message translates to:
  /// **'The dart code is generated successfully. It has copied into Clipboard.'**
  String get generateSucceed;

  /// No description provided for @generateFailed.
  ///
  /// In en, this message translates to:
  /// **'The dart code is generated failed. The error has copied into Clipboard.'**
  String get generateFailed;

  /// No description provided for @inputHelp.
  ///
  /// In en, this message translates to:
  /// **'Please input your json string, and click Format button.'**
  String get inputHelp;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @dataProtection.
  ///
  /// In en, this message translates to:
  /// **'Data Protection'**
  String get dataProtection;

  /// No description provided for @arrayProtection.
  ///
  /// In en, this message translates to:
  /// **'Array Protection'**
  String get arrayProtection;

  /// No description provided for @traverseArrayCount.
  ///
  /// In en, this message translates to:
  /// **'Traverse Array Count'**
  String get traverseArrayCount;

  /// No description provided for @nameRule.
  ///
  /// In en, this message translates to:
  /// **'Name Rule'**
  String get nameRule;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @camelCase.
  ///
  /// In en, this message translates to:
  /// **'CamelCase'**
  String get camelCase;

  /// No description provided for @pascal.
  ///
  /// In en, this message translates to:
  /// **'Pascal'**
  String get pascal;

  /// No description provided for @hungarianNotation.
  ///
  /// In en, this message translates to:
  /// **'Hungarian Notation'**
  String get hungarianNotation;

  /// No description provided for @propertyOrder.
  ///
  /// In en, this message translates to:
  /// **'Property Order'**
  String get propertyOrder;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @addMethod.
  ///
  /// In en, this message translates to:
  /// **'Add Protection Method'**
  String get addMethod;

  /// No description provided for @fileHeader.
  ///
  /// In en, this message translates to:
  /// **'File Header'**
  String get fileHeader;

  /// No description provided for @fileHeaderHelp.
  ///
  /// In en, this message translates to:
  /// **'You can add copyright,dart code, creator into here. support [Date yyyy MM-dd] format to generate time.'**
  String get fileHeaderHelp;

  /// No description provided for @nullsafety.
  ///
  /// In en, this message translates to:
  /// **'Null Safety'**
  String get nullsafety;

  /// No description provided for @nullable.
  ///
  /// In en, this message translates to:
  /// **'Nullable'**
  String get nullable;

  /// No description provided for @smartNullable.
  ///
  /// In en, this message translates to:
  /// **'Smart Nullable'**
  String get smartNullable;

  /// No description provided for @addCopyMethod.
  ///
  /// In en, this message translates to:
  /// **'Add Copy Method'**
  String get addCopyMethod;

  /// No description provided for @duplicateClasses.
  ///
  /// In en, this message translates to:
  /// **'There are duplicate classes'**
  String get duplicateClasses;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @propertyCantSameAsClassName.
  ///
  /// In en, this message translates to:
  /// **'property can\'t the same as Class name'**
  String get propertyCantSameAsClassName;

  /// No description provided for @keywordCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'\'{name}\' is a key word!'**
  String keywordCheckFailed(Object name);

  /// No description provided for @propertyCantSameAsType.
  ///
  /// In en, this message translates to:
  /// **'property can\'t the same as Type'**
  String get propertyCantSameAsType;

  /// No description provided for @containsIllegalCharacters.
  ///
  /// In en, this message translates to:
  /// **'contains illegal characters'**
  String get containsIllegalCharacters;

  /// No description provided for @duplicateProperties.
  ///
  /// In en, this message translates to:
  /// **'There are duplicate properties'**
  String get duplicateProperties;

  /// No description provided for @automaticCheck.
  ///
  /// In en, this message translates to:
  /// **'Automatic Check'**
  String get automaticCheck;

  /// No description provided for @buttonCopyText.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get buttonCopyText;

  /// No description provided for @buttonCopySuccess.
  ///
  /// In en, this message translates to:
  /// **'Copy Success'**
  String get buttonCopySuccess;

  /// No description provided for @resultDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultDialogTitle;

  /// No description provided for @showResultDialog.
  ///
  /// In en, this message translates to:
  /// **'show result dialog'**
  String get showResultDialog;

  /// No description provided for @equalityMethodType.
  ///
  /// In en, this message translates to:
  /// **'Equality Method Type'**
  String get equalityMethodType;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'non-generate'**
  String get none;

  /// No description provided for @official.
  ///
  /// In en, this message translates to:
  /// **'official'**
  String get official;

  /// No description provided for @equatable.
  ///
  /// In en, this message translates to:
  /// **'equatable'**
  String get equatable;

  /// No description provided for @deepCopy.
  ///
  /// In en, this message translates to:
  /// **'deepCopy'**
  String get deepCopy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
