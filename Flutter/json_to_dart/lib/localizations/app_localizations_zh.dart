// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get formatButtonLabel => '格式化';

  @override
  String get generateButtonLabel => '生成';

  @override
  String get settingButtonLabel => '设置';

  @override
  String classNameAssert(Object name) {
    return '${name} 的 Class 名字为空或者空白。';
  }

  @override
  String propertyNameAssert(Object name) {
    return '${name}: 属性名字为空或者空白。';
  }

  @override
  String get formatErrorInfo => '格式化出错. 错误信息已复制到剪切板。';

  @override
  String get timeFormatError => '时间格式不正确。';

  @override
  String get generateSucceed => 'Dart 代码生成成功，已复制到剪切板。';

  @override
  String get generateFailed => 'Dart 代码生成失败，错误信息已复制到剪切板。';

  @override
  String get inputHelp => '请输入Json字符串，按格式化按钮。';

  @override
  String get type => '类型';

  @override
  String get name => '名字';

  @override
  String get dataProtection => '数据保护';

  @override
  String get arrayProtection => '数组保护';

  @override
  String get traverseArrayCount => '数组循环次数';

  @override
  String get nameRule => '名字规则';

  @override
  String get original => '默认';

  @override
  String get camelCase => '小驼峰';

  @override
  String get pascal => '大驼峰';

  @override
  String get hungarianNotation => '匈牙利命名法';

  @override
  String get propertyOrder => '属性排序';

  @override
  String get ascending => '升序';

  @override
  String get descending => '降序';

  @override
  String get addMethod => '添加保护方法';

  @override
  String get fileHeader => '文件头信息';

  @override
  String get fileHeaderHelp =>
      '可以在这里添加 Copyright，导入 Dart 代码，创建人信息等等。支持[Date yyyy MM-dd]来生成时间，Date后面为日期格式.';

  @override
  String get nullsafety => '空安全';

  @override
  String get nullable => '可空';

  @override
  String get autoNullable => '自动可空';
}
