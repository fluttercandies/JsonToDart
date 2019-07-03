import 'package:json_to_dart/src/utils/enums.dart';

class Config {
  bool _addMethod = true;

  /// <summary>
  /// 是否添加数据类型保护和数组保护的方法
  /// 第一次使用了之后，后面不必须再添加
  /// </summary>
  bool get addMethod => _addMethod;

  set addMethod(bool addMethod) {
    _addMethod = addMethod;
  }

  bool _enableDataProtection = false;

  /// <summary>
  /// 数据类型保护
  /// </summary>
  bool get enableDataProtection => _enableDataProtection;

  set enableDataProtection(bool enableDataProtection) {
    _enableDataProtection = enableDataProtection;
  }

  bool _enableArrayProtection = false;

  /// <summary>
  /// 循环数组的时候，防止出错一个，全部挂掉
  /// </summary>
  bool get enableArrayProtection => _enableArrayProtection;

  set enableArrayProtection(bool enableArrayProtection) {
    _enableArrayProtection = enableArrayProtection;
  }

  int _traverseArrayCount = 1;

  /// <summary>
  /// 数组循环次数，通过遍历数组来merge属性，防止漏掉属性（有时候同一个类有不同的属性）
  /// List<T>
  /// 1,20,99
  /// </summary>
  int get traverseArrayCount => _traverseArrayCount;

  set traverseArrayCount(int traverseArrayCount) {
    _traverseArrayCount = traverseArrayCount;
  }

  String _fileHeaderInfo = "";

  /// <summary>
  /// 文件头部信息，作者，时间，详情等
  /// [time]
  /// </summary>
  String get fileHeaderInfo => _fileHeaderInfo;

  set fileHeaderInfo(String fileHeaderInfo) {
    _fileHeaderInfo = fileHeaderInfo;
  }

  PropertyNamingConventionsType _propertyNamingConventionsType =
      PropertyNamingConventionsType.camelCase;

  /// <summary>
  /// 属性命名规则
  /// </summary>
  PropertyNamingConventionsType get propertyNamingConventionsType =>
      _propertyNamingConventionsType;

  set propertyNamingConventionsType(
      PropertyNamingConventionsType propertyNamingConventionsType) {
    _propertyNamingConventionsType = propertyNamingConventionsType;
  }

  PropertyAccessorType _propertyAccessorType=PropertyAccessorType.none;

  /// <summary>
  /// 属性访问器
  /// </summary>
  PropertyAccessorType get propertyAccessorType => _propertyAccessorType;

  set propertyAccessorType(PropertyAccessorType propertyAccessorType) {
    _propertyAccessorType = propertyAccessorType;
  }

  PropertyNameSortingType _propertyNameSortingType=PropertyNameSortingType.none;

  /// <summary>
  /// 根据属性名字升序/降序/不变排序
  /// </summary>
  PropertyNameSortingType get propertyNameSortingType =>
      _propertyNameSortingType;

  set propertyNameSortingType(PropertyNameSortingType propertyNameSortingType) {
    _propertyNameSortingType = propertyNameSortingType;
  }

  double _column1Width = 1.5;

  double get column1Width => _column1Width;

  set column1Width(double column1Width) {
    _column1Width = column1Width;
  }

  double _column2Width = 2.0;

  double get column2Width => _column2Width;

  set column2Width(double column2Width) {
    _column2Width = column2Width;
  }
}
