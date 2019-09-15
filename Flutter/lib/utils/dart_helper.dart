
import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/models/extended_property.dart';

import 'enums.dart';

class DartHelper {
  static const String classHeader = "class {0} {";
  static const classFooter = "}";

  static const String fromJsonHeader =
      "  factory {0}.fromJson(jsonRes)=>jsonRes == null? null:{0}(";
  static const String fromJsonHeader1 =
      "  factory {0}.fromJson(jsonRes){ if(jsonRes == null) return null;\n";
  static const String fromJsonFooter = ");";
  static const String fromJsonFooter1 = "return {0}({1});}";
  static const String toJsonHeader = "  Map<String, dynamic> toJson() => {";
  static const String toJsonFooter = "};";
  static const String toJsonSetString = "        '{0}': {1},";
  static const String jsonImport = "import 'dart:convert' show json;";
  static const String debugPrintImport =
      "import 'package:flutter/foundation.dart';";
  static const String propertyString = "  {0} {1};";
  static const String propertyStringFinal = "  final {0} {1};";
  static const String propertyStringGet = "  {0} _{2};\n  {0} get {1} => _{2};";
  static const String propertyStringGetSet =
      "  {0} _{2};\n  {0} get {1} => _{2};\n  set {1}(value)  {\n    _{2} = value;\n  }\n";

  static String setProperty(
      String setName, ExtendedProperty item, String className) {
    if (appConfig.enableDataProtection) {
      return "    $setName : convertValueByType(jsonRes['${item.key}'],${item.value.runtimeType.toString()},stack:\"$className-${item.key}\"),";
    } else {
      return "    $setName : jsonRes['${item.key}'],";
    }
  }

  static const String setObjectProperty =
      "    {0} : {2}.fromJson(jsonRes['{1}']),";
  static String propertyS(PropertyAccessorType type) {
    switch (type) {
      case PropertyAccessorType.none:
        return propertyString;
      case PropertyAccessorType.Final:
        return propertyStringFinal;
      case PropertyAccessorType.get:
        return propertyStringGet;
      case PropertyAccessorType.getSet:
        return propertyStringGetSet;
    }
    return "";
  }

  static String getSetPropertyString(ExtendedProperty property) {
    var name = property.name;
    switch (property.propertyAccessorType) {
      case PropertyAccessorType.none:
      case PropertyAccessorType.Final:
        return name;
      case PropertyAccessorType.get:
      case PropertyAccessorType.getSet:
        var lowName = name.substring(0, 1).toLowerCase() + name.substring(1);
        return "_" + lowName;
    }

    return name;
  }

  static String getDartTypeString(DartType dartType) {
    switch (dartType) {
      case DartType.string:
        return "String";
      case DartType.int:
        return "int";

      case DartType.object:
        return "Object";

      case DartType.bool:
        return "bool";

      case DartType.double:
        return "double";
      default:
        return "";
    }
  }

  static const String factoryStringHeader = "    {0}({";
  static const String factoryStringFooter = "    });\n";

  static String factorySetString(PropertyAccessorType type) {
    switch (type) {
      case PropertyAccessorType.none:
      case PropertyAccessorType.Final:
        return "this.{0},";
      case PropertyAccessorType.get:
      case PropertyAccessorType.getSet:
        return "{0} {1},";
    }
    return "this.{0},";
  }

  static const String classToString =
      "  @override\nString  toString() {\n    return json.encode(this);\n  }";

  static DartType converDartType(Type type) {
    if (type == int) {
      return DartType.int;
    } else if (type == double || type == num) {
      return DartType.double;
    } else if (type == String) {
      return DartType.string;
    } else if (type == bool) {
      return DartType.bool;
    }

    return DartType.object;
  }

  static const String tryCatchMethod = """void tryCatch(Function f) 
      { try {f?.call();} 
      catch (e, stack)
       { 
        debugPrint("\$e"); \n  debugPrint("\$stack");
        }
        }""";

  static const String convertMethod = """
  dynamic convertValueByType(value, Type type, {String stack: ""}) {
  if (value == null) {
    debugPrint("\$stack : value is null");
    if (type == String) {
      return "";
    } else if (type == int) {
      return 0;
    } else if (type == double) {
      return 0.0;
    } else if (type == bool) {
      return false;
    }
    return null;
  }

  if (value.runtimeType == type) {
    return value;
  }
  var valueS = value.toString();
  debugPrint("\$stack : \${value.runtimeType} is not \$type type");
  if (type == String) {
    return valueS;
  } else if (type == int) {
    return int.tryParse(valueS);
  } else if (type == double) {
    return double.tryParse(valueS);
  } else if (type == bool) {
    valueS = valueS.toLowerCase();
    var intValue = int.tryParse(valueS);
    if (intValue != null) {
      return intValue == 1;
    }
    return valueS == "true";
  }
}
""";
}
