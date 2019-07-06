import 'package:json_to_dart_library/src/utils/enums.dart';
import 'dart:convert' show json;

Config appConfig = Config();

class Config {
  /// <summary>
  /// 是否添加数据类型保护和数组保护的方法
  /// 第一次使用了之后，后面不必须再添加
  /// </summary>
  bool addMethod;
  int column1Width;
  int column2Width;
  bool enableArrayProtection;

  /// <summary>
  /// 数据类型保护
  /// </summary>
  bool enableDataProtection;
  String fileHeaderInfo;
  PropertyNamingConventionsType _propertyNamingConventionsType =
      PropertyNamingConventionsType.camelCase;
  int _propertyNamingConventionsTypeJson = 0;

  /// <summary>
  /// 属性命名规则
  /// </summary>
  PropertyNamingConventionsType get propertyNamingConventionsType =>
      _propertyNamingConventionsType;

  set propertyNamingConventionsType(
      PropertyNamingConventionsType propertyNamingConventionsType) {
    _propertyNamingConventionsType = propertyNamingConventionsType;
    _propertyNamingConventionsTypeJson = PropertyNamingConventionsType.values
        .indexOf(_propertyNamingConventionsType);
  }

  PropertyAccessorType _propertyAccessorType = PropertyAccessorType.none;
  int _propertyAccessorTypeJson = 0;

  /// <summary>
  /// 属性访问器
  /// </summary>
  PropertyAccessorType get propertyAccessorType => _propertyAccessorType;

  set propertyAccessorType(PropertyAccessorType propertyAccessorType) {
    _propertyAccessorType = propertyAccessorType;
    _propertyAccessorTypeJson =
        PropertyAccessorType.values.indexOf(_propertyAccessorType);
  }

  PropertyNameSortingType _propertyNameSortingType =
      PropertyNameSortingType.none;
  int _propertyNameSortingTypeJson = 0;

  /// <summary>
  /// 根据属性名字升序/降序/不变排序
  /// </summary>
  PropertyNameSortingType get propertyNameSortingType =>
      _propertyNameSortingType;

  set propertyNameSortingType(PropertyNameSortingType propertyNameSortingType) {
    _propertyNameSortingType = propertyNameSortingType;
    _propertyNameSortingTypeJson =
        PropertyNameSortingType.values.indexOf(_propertyNameSortingType);
  }

  /// <summary>
  /// 循环数组的时候，防止出错一个，全部挂掉
  /// </summary>
  int traverseArrayCount;

  Config({
    this.addMethod = true,
    this.column1Width = 2,
    this.column2Width = 3,
    this.enableArrayProtection = false,
    this.enableDataProtection = false,
    this.fileHeaderInfo = "",
    int propertyAccessorType = 0,
    int propertyNameSortingType = 0,
    int propertyNamingConventionsType = 0,
    this.traverseArrayCount = 1,
  })  : _propertyAccessorType =
            PropertyAccessorType.values[propertyAccessorType],
        _propertyNameSortingType =
            PropertyNameSortingType.values[propertyNameSortingType],
        _propertyNamingConventionsType =
            PropertyNamingConventionsType.values[propertyNamingConventionsType];

  factory Config.fromJson(jsonRes) => jsonRes == null
      ? null
      : Config(
          addMethod: jsonRes['addMethod'],
          column1Width: jsonRes['column1Width'],
          column2Width: jsonRes['column2Width'],
          enableArrayProtection: jsonRes['enableArrayProtection'],
          enableDataProtection: jsonRes['enableDataProtection'],
          fileHeaderInfo: jsonRes['fileHeaderInfo'],
          propertyAccessorType: jsonRes['propertyAccessorType'],
          propertyNameSortingType: jsonRes['propertyNameSortingType'],
          propertyNamingConventionsType:
              jsonRes['propertyNamingConventionsType'],
          traverseArrayCount: jsonRes['traverseArrayCount'],
        );

  Map<String, dynamic> toJson() => {
        'addMethod': addMethod,
        'column1Width': column1Width,
        'column2Width': column2Width,
        'enableArrayProtection': enableArrayProtection,
        'enableDataProtection': enableDataProtection,
        'fileHeaderInfo': fileHeaderInfo,
        'propertyAccessorType': _propertyAccessorTypeJson,
        'propertyNameSortingType': _propertyNameSortingTypeJson,
        'propertyNamingConventionsType': _propertyNamingConventionsTypeJson,
        'traverseArrayCount': traverseArrayCount,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}
