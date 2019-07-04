import 'package:json_to_dart/src/utils/config_helper.dart';
import 'package:json_to_dart/src/utils/enums.dart';
import 'package:json_to_dart/src/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/src/utils/dart_helper.dart';
import 'package:json_to_dart/src/utils/my_string_buffer.dart';
import 'package:json_to_dart/src/utils/string_helper.dart';

class ExtendedProperty {
  final String uid;
  final int depth;
  final String key;
  final dynamic value;
  final MapEntry<String, dynamic> keyValuePair;
  String name;
  PropertyAccessorType propertyAccessorType=PropertyAccessorType.none;

  DartType type;

  ExtendedProperty({String uid, this.depth, this.keyValuePair})
      : key = keyValuePair.key,
        uid = uid + "_" + keyValuePair.key,
        value = keyValuePair.value,
        name = keyValuePair.key,
        propertyAccessorType = ConfigHelper().config.propertyAccessorType,
        type = DartHelper.converDartType(keyValuePair.value.runtimeType);

  void updateNameByNamingConventionsType() {
    switch (ConfigHelper().config.propertyNamingConventionsType) {
      case PropertyNamingConventionsType.none:
        this.name = name ?? key;
        break;
      case PropertyNamingConventionsType.camelCase:
        this.name = camelName(name ?? key);
        break;
      case PropertyNamingConventionsType.pascal:
        this.name = upcaseCamelName(name ?? key);
        break;
      case PropertyNamingConventionsType.hungarianNotation:
        this.name = underScoreName(name ?? key);
        break;
      default:
        this.name = name ?? key;
        break;
    }
  }

  void updatePropertyAccessorType() {
    propertyAccessorType = ConfigHelper().config.propertyAccessorType;
  }

  String getTypeString({String className}) {
    var temp = value;
    String result;

    while (temp is List) {
      if (result == null)
        result = "List<{0}>";
      else
        result = stringFormat("List<{0}>", <dynamic>[result]);
      if (temp is List && temp.length > 0) {
        temp = temp.first;
      } else {
        break;
      }
    }

    if (result != null) {
      result = stringFormat(result, <dynamic>[
        className ??
            DartHelper.getDartTypeString(
                DartHelper.converDartType(temp?.runtimeType ?? Object))
      ]);
    }

    return result ?? (className ?? DartHelper.getDartTypeString(type));
  }

  String getArraySetPropertyString(String setName, String typeString,
      {String className}) {
    var temp = value;
    MyStringBuffer sb = new MyStringBuffer();
    sb.writeLine(
        "    $typeString $setName = jsonRes['$key'] is List ? []: null; ");
    sb.writeLine("    if($setName!=null) {");
    bool enableTryCatch = ConfigHelper().config.enableArrayProtection;
    int count = 0;
    String result;
    while (temp is List) {
      if (temp is List && temp.length > 0) {
        temp = temp.first;
      } else {
        temp = null;
      }

      ///下层为数组
      if (temp != null && temp is List) {
        //删掉List<
        typeString = typeString.substring("List<".length);
        //删掉>
        typeString = typeString.substring(0, typeString.length - 1);
        if (count == 0) {
          result =
              " for (var item$count in jsonRes['$key']) { if (item$count != null) { $typeString items${count + 1} = []; {} $setName.add(items${count + 1}); }";
        } else {
          result = result.replaceAll("{}",
              " for (var item$count in item${count - 1} is List ? item${count - 1} :[]) { if (item$count != null) { $typeString items${count + 1} = []; {} items$count.add(items${count + 1}); }");
        }
      }

      ///下层不为数组
      else {
        var item = ("item" + (count == 0 ? "" : count.toString()));
        var addString = "";
        if (className != null) {
          item = "$className.fromJson($item)";
        }

        if (count == 0) {
          addString = "$setName.add($item); ";
          if (enableTryCatch) {
            addString = "tryCatch(() { $addString }); ";
          }

          result =
              " for (var item in jsonRes['$key']) { if (item != null) { $addString }";
        } else {
          addString = "items$count.add($item); ";

          if (enableTryCatch) {
            addString = "tryCatch(() { $addString }); ";
          }

          result = result.replaceAll("{}",
              " for (var item$count in item${count - 1} is List ? item${count - 1} :[]) { if (item$count != null) $addString}");
        }
      }

      count++;
    }

    sb.writeLine(result);
    sb.writeLine("    }");
    sb.writeLine("    }\n");

    return sb.toString();
  }
}
