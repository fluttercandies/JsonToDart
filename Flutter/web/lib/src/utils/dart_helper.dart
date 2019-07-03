import 'package:json_to_dart_web/src/models/extended_property.dart';

import 'config_helper.dart';
import 'enums.dart';

class DartHelper {
  static const String ClassHeader = "class {0} {{";
  static const ClassFooter = "}";

  static const String FromJsonHeader =
      "  factory {0}.fromJson(jsonRes)=>jsonRes == null? null:{0}(";
  static const String FromJsonHeader1 =
      "  factory {0}.fromJson(jsonRes){{ if(jsonRes == null) return null;\n";
  static const String FromJsonFooter = ");";
  static const String FromJsonFooter1 = "return {0}({1});}}";
  static const String ToJsonHeader = "  Map<String, dynamic> toJson() => {";
  static const String ToJsonFooter = "};";
  static const String ToJsonSetString = "        '{0}': {1},";
  static const String JsonImport = "import 'dart:convert' show json;";
  static const String DebugPrintImport =
      "import 'package:flutter/foundation.dart';";
  static const String PropertyString = "  {0} {1};";
  static const String PropertyStringFinal = "  final {0} {1};";
  static const String PropertyStringGet = "  {0} _{2};\n  {0} get {1} => _{2};";
  static const String PropertyStringGetSet =
      "  {0} _{2};\n  {0} get {1} => _{2};\n  set {1}(value)  {{\n    _{2} = value;\n  }}\n";

  static String SetProperty(
      String setName, ExtendedProperty item, String className) {
    if (ConfigHelper().config.enableDataProtection) {
      return "    {setName} : convertValueByType(jsonRes['${item.key}'],${item.value.runtimeType.toString()},stack:\"${className}-${item.key}\"),";
    } else {
      return "    {setName} : jsonRes['${item.key}'],";
    }
  }

  static const String SetObjectProperty =
      "    {0} : {2}.fromJson(jsonRes['{1}']),";
  static String PropertyS(PropertyAccessorType type) {
    switch (type) {
      case PropertyAccessorType.none:
        return PropertyString;
      case PropertyAccessorType.Final:
        return PropertyStringFinal;
      case PropertyAccessorType.get:
        return PropertyStringGet;
      case PropertyAccessorType.getSet:
        return PropertyStringGetSet;
    }
    return "";
  }

  static String GetSetPropertyString(ExtendedProperty property) {
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

  static String GetDartTypeString(DartType dartType) {
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

  static const String FactoryStringHeader = "    {0}({{";
  static const String FactoryStringFooter = "    });\n";

  static String FactorySetString(PropertyAccessorType type) {
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

  static const String ClassToString =
      "  @override\nString  toString() {\n    return json.encode(this);\n  }";

  //  static DartType ConverDartType(JTokenType type)
  //   {
  //       switch (type)
  //       {
  //           case JTokenType.None:
  //               break;
  //           case JTokenType.Object:
  //               return DartType.Object;
  //           case JTokenType.Array:
  //               break;
  //           case JTokenType.Constructor:
  //               break;
  //           case JTokenType.Property:
  //               break;
  //           case JTokenType.Comment:
  //               return DartType.String;
  //           case JTokenType.Integer:
  //               return DartType.Int;
  //           case JTokenType.Float:
  //               return DartType.Double;
  //           case JTokenType.String:
  //               return DartType.String;
  //           case JTokenType.Boolean:
  //               return DartType.Bool;
  //           case JTokenType.Null:
  //               break;
  //           case JTokenType.Undefined:
  //               break;
  //           case JTokenType.Date:
  //               return DartType.String;
  //           case JTokenType.Raw:
  //               break;
  //           case JTokenType.Bytes:
  //               return DartType.String;
  //           case JTokenType.Guid:
  //               return DartType.String;
  //           case JTokenType.Uri:
  //               return DartType.String;
  //           case JTokenType.TimeSpan:
  //               return DartType.String;
  //           default:
  //               break;
  //       }
  //       return DartType.Object;
  //   }

//         static const String ConvertMethod = "'dynamic convertValueByType(value, Type type, {String stack: \"\") {
//   if (value == null) {debugPrint(\"stack : value is null\");

//   if (type == String) {return \"\";} else if (type == int) {return 0;} else if (type == double) { return 0.0; } else if (type == bool) {  return false; } return null;}

//   if (value.runtimeType == type) {
//     return value;
//   }
// var valueS = value.toString();
// debugPrint(\"\$stack : \${value.runtimeType} is not \$type type\");
//   if (type == String) {
//     return valueS;
//   } else if (type == int) {
//     return int.tryParse(valueS);
//   } else if (type == double) {
//     return double.tryParse(valueS);
//   } else if (type == bool) {
//     valueS = valueS.toLowerCase();
//     var intValue = int.tryParse(valueS);
//     if (intValue != null) {
//       return intValue == 1;
//     }
//     return valueS == \"true\";
//   }
// }"';
  static const String TryCatchMethod =
      "void tryCatch(Function f) { try {f?.call();} catch (e, stack) { debugPrint(\$e); \n  debugPrint(\$stack);}}";
}
