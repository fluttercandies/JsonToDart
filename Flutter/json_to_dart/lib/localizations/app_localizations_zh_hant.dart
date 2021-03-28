// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations_zh.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Chinese (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant([String locale = 'zh_Hant']) : super(locale);

  @override
  String get settingButtonLabel => '設置';

  @override
  String classNameAssert(Object name) {
    return '${name} 的 Class 名字為空或者空白。';
  }

  @override
  String propertyNameAssert(Object name) {
    return '${name}: 屬性名字為空或者空白。';
  }

  @override
  String get formatErrorInfo => '格式化出錯. 錯誤資訊已複製到剪切板。';

  @override
  String get timeFormatError => '時間格式不正確。';

  @override
  String get generateSucceed => 'Dart 代碼生成成功，已複製到剪切板。';

  @override
  String get generateFailed => 'Dart 代碼生成失敗，錯誤資訊已複製到剪切板。';

  @override
  String get inputHelp => '請輸入Json字串，按格式化按鈕。';

  @override
  String get type => '類型';

  @override
  String get dataProtection => '數據保護';

  @override
  String get arrayProtection => '數組保護';

  @override
  String get traverseArrayCount => '數組迴圈次數';

  @override
  String get nameRule => '名字規則';

  @override
  String get original => '默認';

  @override
  String get camelCase => '小駝峰';

  @override
  String get pascal => '大駝峰';

  @override
  String get hungarianNotation => '匈牙利命名法';

  @override
  String get propertyOrder => '屬性排序';

  @override
  String get ascending => '昇冪';

  @override
  String get descending => '降序';

  @override
  String get addMethod => '添加保護方法';

  @override
  String get fileHeader => '檔頭資訊';

  @override
  String get fileHeaderHelp =>
      '可以在這裏添加 Copyright，導入 Dart 代碼，創建人資訊等等。支持[Date yyyy MM-dd]來生成時間，Date後面為日期格式.';
}
