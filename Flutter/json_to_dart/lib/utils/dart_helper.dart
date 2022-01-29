import 'package:json_to_dart/models/dart_property.dart';

import '../models/config.dart';
import '../models/dart_property.dart';
import 'enums.dart';

class DartHelper {
  const DartHelper._();
  static const String classHeader = 'class {0} {';
  static const String classFooter = '}';
  static const String jsonRes = 'json';

  static const String fromJsonHeader =
      '  factory {0}.fromJson(Map<String, dynamic> ${DartHelper.jsonRes})=>${DartHelper.jsonRes} == null? null:{0}(';
  static const String fromJsonHeader1 =
      '  factory {0}.fromJson(Map<String, dynamic> ${DartHelper.jsonRes}){ if(${DartHelper.jsonRes} == null) {return null;}\n';
  static const String fromJsonHeaderNullSafety =
      '  factory {0}.fromJson(Map<String, dynamic> ${DartHelper.jsonRes})=>{0}(';
  static const String fromJsonHeader1NullSafety =
      '  factory {0}.fromJson(Map<String, dynamic> ${DartHelper.jsonRes}){\n';
  static const String fromJsonFooter = ');';
  static const String fromJsonFooter1 = 'return {0}({1});}';
  static const String toJsonHeader =
      '  Map<String, dynamic> toJson() => <String, dynamic>{';
  static const String toJsonFooter = '};';

  static const String copyWithHeader =
      '  Map<String, dynamic> toJson() => <String, dynamic>{';
  static const String copyWithFooter = '};';

  static const String toJsonSetString = "        '{0}': {1},";
  static const String jsonImport = '''
import 'dart:convert';''';
  static const String propertyString = '  {0} {1};';
  static const String propertyStringFinal = '  final {0} {1};';
  static const String propertyStringGet = '  {0} _{2};\n  {0} get {1} => _{2};';
  static const String propertyStringGetSet =
      '  {0} _{2};\n  {0} get {1} => _{2};\n  set {1}(value)  {\n    _{2} = value;\n  }\n';

  static String setProperty(
      String setName, DartProperty item, String? className) {
    return '    $setName : ${getUseAsT(getDartTypeString(item.type.value, item), "${DartHelper.jsonRes}['${item.key}']")},';
    // if (appConfig.enableDataProtection) {
    //   return "    $setName : convertValueByType(${DartHelper.jsonRes}['${item.key}'],${item.value.runtimeType.toString()},stack:\"$className-${item.key}\"),";
    // } else {
    //   return "    $setName : ${DartHelper.jsonRes}['${item.key}'],";
    // }
  }

  static const String setObjectProperty =
      "    {0} :{3} {2}.fromJson(asT<Map<String, dynamic>>(${DartHelper.jsonRes}['{1}']){4}),";

  static String propertyS(PropertyAccessorType type) {
    switch (type) {
      case PropertyAccessorType.none:
        return propertyString;
      case PropertyAccessorType.final_:
        return propertyStringFinal;
      // case PropertyAccessorType.get_:
      //   return propertyStringGet;
      // case PropertyAccessorType.getSet:
      //   return propertyStringGetSet;
    }
  }

  static String getSetPropertyString(DartProperty property) {
    final String name = property.name.value;
    switch (property.propertyAccessorType.value) {
      case PropertyAccessorType.none:
      case PropertyAccessorType.final_:
        return name;
      // case PropertyAccessorType.get_:
      // case PropertyAccessorType.getSet:s
      //   final String lowName =
      //       name.substring(0, 1).toLowerCase() + name.substring(1);
      //   return '_' + lowName;
    }
  }

  static String getDartTypeString(DartType dartType, DartProperty item) {
    final bool nullable = ConfigSetting().nullsafety && item.nullable;
    final String type = dartType.text;
    return nullable ? type + '?' : type;
  }

  static const String factoryStringHeader = '    {0}({';
  static const String factoryStringFooter = '    });\n';

  static String factorySetString(
    PropertyAccessorType type,
    bool nullable,
  ) {
    switch (type) {
      case PropertyAccessorType.none:
      case PropertyAccessorType.final_:
        return nullable ? 'this.{0},' : 'required this.{0},';
      // case PropertyAccessorType.get_:
      // case PropertyAccessorType.getSet:
      //   return '{0} {1},';
    }
  }

  static const String classToString =
      '  \n@override\nString  toString() {\n    return jsonEncode(this);\n  }';

  static const String classToClone =
      '\n{0} clone() => {0}.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this))){1});\n';

  static DartType converDartType(Type type) {
    if (type == int) {
      return DartType.int;
    } else if (type == double || type == num) {
      return DartType.double;
    } else if (type == String) {
      return DartType.String;
    } else if (type == bool) {
      return DartType.bool;
    } else if (type == Null) {
      return DartType.Null;
    }

    return DartType.Object;
  }

  static bool converNullable(dynamic value) {
    return value.runtimeType == Null;
  }

  static const String tryCatchMethod = """void tryCatch(Function f)
      { try {f?.call();}
      catch (e, stack)
       {
        log('\$e'); \n  log('\$stack');
        }
        }""";
  static const String tryCatchMethodNullSafety = """void tryCatch(Function? f)
      { try {f?.call();}
      catch (e, stack)
       {
        log('\$e'); \n  log('\$stack');
        }
        }""";
  static const String asTMethod = '''
T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}
 ''';

  static const String asTMethodNullSafety = '''
T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}
 ''';
  static const String asTMethodWithDataProtection = '''
class FFConvert {
  FFConvert._();

  static T Function<T>(dynamic value) convert = <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T;
  };
}

T asT<T>(dynamic value, [T defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<\$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

 ''';

  static const String asTMethodWithDataProtectionNullSafety = '''
class FFConvert {
  FFConvert._();
  static T? Function<T extends Object?>(dynamic value) convert =
      <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  };
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<\$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}
 ''';

  static String getUseAsT(String? par1, String par2) {
    String asTString = 'asT<$par1>($par2)';
    if (ConfigSetting().nullsafety && par1 != null && !par1.contains('?')) {
      asTString += '!';
    }
    return asTString;
  }

  static const String copyMethodString = '''

    {0} copy() {
    return {0}(
      {1}
    );
  }
  ''';
}
