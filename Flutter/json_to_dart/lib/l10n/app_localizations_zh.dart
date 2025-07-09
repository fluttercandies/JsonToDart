// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

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
    return '$name 的 Class 名字为空。';
  }

  @override
  String propertyNameAssert(Object name) {
    return '$name: 属性名字为空。';
  }

  @override
  String get formatErrorInfo => '格式化出错. 错误信息已复制到剪切板。';

  @override
  String get illegalJson => 'Json格式不正確';

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
  String get smartNullable => '智能可空';

  @override
  String get addCopyMethod => '添加复制方法';

  @override
  String get duplicateClasses => '包含重复的类';

  @override
  String get warning => '警告';

  @override
  String get ok => '确认';

  @override
  String get propertyCantSameAsClassName => '属性名不能为类名';

  @override
  String keywordCheckFailed(Object name) {
    return '\'$name\' 是关键字!';
  }

  @override
  String get propertyCantSameAsType => '属性名不能跟类型相同';

  @override
  String get containsIllegalCharacters => '包含非法字符';

  @override
  String get duplicateProperties => '属性名重复';

  @override
  String get automaticCheck => '自动校验';

  @override
  String get buttonCopyText => '复制';

  @override
  String get buttonCopySuccess => '复制成功';

  @override
  String get resultDialogTitle => '结果';

  @override
  String get showResultDialog => '显示结果弹框';

  @override
  String get equalityMethodType => '对比相等方法类型';

  @override
  String get none => '不生成';

  @override
  String get official => '官方方式';

  @override
  String get equatable => 'Equatable 的方式';

  @override
  String get deepCopy => '深复制';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get formatButtonLabel => '格式化';

  @override
  String get generateButtonLabel => '生成';

  @override
  String get settingButtonLabel => '設置';

  @override
  String classNameAssert(Object name) {
    return '$name 的 Class 名字為空。';
  }

  @override
  String propertyNameAssert(Object name) {
    return '$name: 屬性名字為空。';
  }

  @override
  String get formatErrorInfo => '格式化出错. 錯誤資訊已複製到剪切板。';

  @override
  String get illegalJson => 'Json格式不正确';

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
  String get name => '名字';

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
  String get fileHeader => '文件头信息';

  @override
  String get fileHeaderHelp =>
      '可以在這裏添加 Copyright，導入 Dart 代碼，創建人資訊等等。支持[Date yyyy MM-dd]來生成時間，Date後面為日期格式。';

  @override
  String get nullsafety => '空安全';

  @override
  String get nullable => '可空';

  @override
  String get smartNullable => '智能可空';

  @override
  String get addCopyMethod => '添加複製方法';

  @override
  String get duplicateClasses => '包含重複的類';

  @override
  String get warning => '警告';

  @override
  String get ok => '確認';

  @override
  String get propertyCantSameAsClassName => '屬性名不能為類名';

  @override
  String keywordCheckFailed(Object name) {
    return '\'$name\' 是關鍵字!';
  }

  @override
  String get propertyCantSameAsType => '屬性名不能跟類型相同';

  @override
  String get containsIllegalCharacters => '包含非法字符';

  @override
  String get duplicateProperties => '屬性名重複';

  @override
  String get automaticCheck => '自動校驗';

  @override
  String get buttonCopyText => '複製';

  @override
  String get buttonCopySuccess => '複製成功';

  @override
  String get resultDialogTitle => '結果';

  @override
  String get showResultDialog => '顯示結果彈框';

  @override
  String get equalityMethodType => '對比相等方法類型';

  @override
  String get none => '不生成';

  @override
  String get official => '官方方式';

  @override
  String get equatable => 'Equatable 的方式';

  @override
  String get deepCopy => '深複製';
}
