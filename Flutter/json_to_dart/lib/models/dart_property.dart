import 'package:equatable/equatable.dart';

import 'package:get/get.dart';

import 'package:json_to_dart/main_controller.dart';
import 'package:json_to_dart/models/dart_object.dart';
import 'package:json_to_dart/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/utils/dart_helper.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:json_to_dart/utils/error_check/error_checker.dart';
import 'package:json_to_dart/utils/error_check/text_editing_controller.dart';
import 'package:json_to_dart/utils/my_string_buffer.dart';
import 'package:json_to_dart/utils/string_helper.dart';

import 'config.dart';

// ignore: must_be_immutable
class DartProperty extends Equatable {
  DartProperty({
    required String uid,
    required this.depth,
    required this.keyValuePair,
    required this.nullable,
    this.dartObject,
  }) {
    key = keyValuePair.key;
    this.uid = uid + '_' + keyValuePair.key;
    nullableObs.value = nullable;
    propertyAccessorType.value = ConfigSetting().propertyAccessorType.value;
    type.value = DartHelper.converDartType(keyValuePair.value.runtimeType);
    name.value = keyValuePair.key;

    nameTextEditingController = PropertyNameCheckerTextEditingController(this);
    nameTextEditingController.text = name.value;
    value = keyValuePair.value;

    Get.find<MainController>().allProperties.add(this);
    emptyErrorChecker = EmptyErrorChecker(this);
    errors.add(emptyErrorChecker);
    errors.add(ValidityChecker(this));
    errors.add(DuplicatePropertyNameChecker(this));
    errors.add(PropertyAndClassNameSameChecker(this));
  }

  final DartObject? dartObject;
  late String uid;
  late int depth;
  late final String key;
  late final dynamic value;
  final MapEntry<String, dynamic> keyValuePair;
  RxString name = ''.obs;

  late PropertyNameCheckerTextEditingController nameTextEditingController;
  Rx<PropertyAccessorType> propertyAccessorType = PropertyAccessorType.none.obs;
  bool nullable = false;
  RxBool nullableObs = false.obs;
  Rx<DartType> type = DartType.Object.obs;

  RxSet<String> propertyError = <String>{}.obs;

  List<DartErrorChecker> errors = <DartErrorChecker>[];

  bool get hasPropertyError => propertyError.isNotEmpty;
  late EmptyErrorChecker emptyErrorChecker;
  void updateError(RxString input) {
    if (!ConfigSetting().automaticCheck.value) {
      emptyErrorChecker.checkError(input);
      return;
    }
    for (final DartErrorChecker error in errors) {
      error.checkError(input);
    }
  }

  void updateNameByNamingConventionsType() {
    String name = this.name.value;
    switch (ConfigSetting().propertyNamingConventionsType.value) {
      case PropertyNamingConventionsType.none:
        name = key;
        break;
      case PropertyNamingConventionsType.camelCase:
        name = camelName(key);
        break;
      case PropertyNamingConventionsType.pascal:
        name = upcaseCamelName(key);
        break;
      case PropertyNamingConventionsType.hungarianNotation:
        name = underScoreName(key);
        break;
      default:
        name = key;
        break;
    }

    this.name.value = correctName(name, dartProperty: this);
    nameTextEditingController.text = this.name.value;
    updateError(this.name);
  }

  void updatePropertyAccessorType() {
    propertyAccessorType.value = ConfigSetting().propertyAccessorType.value;
  }

  void updateNullable(bool nullable) {
    this.nullable = nullable;
    nullableObs.value = nullable;
  }

  String getTypeString({String? className}) {
    dynamic temp = value;
    String? result;

    while (temp is List) {
      if (result == null) {
        result = 'List<{0}>';
      } else {
        result = stringFormat('List<{0}>', <String>[result]);
      }
      if (temp.isNotEmpty) {
        temp = temp.first;
      } else {
        break;
      }
    }

    if (result != null) {
      result = stringFormat(result, <String>[
        className ??
            DartHelper.getDartTypeString(
                DartHelper.converDartType(temp?.runtimeType ?? Object), this)
      ]);
    }

    return result ??
        (className ?? DartHelper.getDartTypeString(type.value, this));
  }

  String getListCopy({String? className}) {
    // if (className == null) {
    //   return '$name$toList';
    // }
    dynamic temp = value;
    String copy = '';
    String type = '{0}';

    while (temp is List && temp.isNotEmpty) {
      if (copy == '') {
        copy =
            'e.map(($type e) => ${className != null ? 'e.copy()' : 'e'}).toList()';
      } else {
        type = 'List<$type>';
        copy = 'e.map(($type e)=> $copy).toList()';
      }
      if (temp.isNotEmpty) {
        temp = temp.first;
      }
    }

    //type = 'List<$type>';
    // copy =
    //     '${ConfigSetting().nullsafety && !nullable ? name : name + '?'}.map(($type e)=> $copy)$toList';
    copy = stringFormat(copy, <String>[
      className ??
          DartHelper.getDartTypeString(
                  DartHelper.converDartType(temp?.runtimeType ?? Object), this)
              .replaceAll('?', '')
    ]);
    copy = copy.replaceFirst(
      'e',
      ConfigSetting().nullsafety.value && !nullable ? name.value : name + '?',
    );

    if (!ConfigSetting().nullsafety.value) {
      copy = copy.replaceRange(
          copy.length - '.toList()'.length, null, '?.toList()');
    }
    return copy;
  }

  String getBaseTypeString({String? className}) {
    if (className != null) {
      return className;
    }
    dynamic temp = value;
    while (temp is List) {
      if (temp.isNotEmpty) {
        temp = temp.first;
      } else {
        break;
      }
    }

    return DartHelper.getDartTypeString(
        DartHelper.converDartType(temp?.runtimeType ?? Object), this);
  }

  String getArraySetPropertyString(String setName, String typeString,
      {String? className, String? baseType}) {
    dynamic temp = value;
    final MyStringBuffer sb = MyStringBuffer();
    sb.writeLine(
        " final  ${ConfigSetting().nullsafety.value ? typeString + '?' : typeString} $setName = ${DartHelper.jsonRes}['$key'] is List ? ${typeString.substring('List'.length).replaceAll('?', '')}[]: null; ");
    sb.writeLine('    if($setName!=null) {');
    final bool enableTryCatch = ConfigSetting().enableArrayProtection.value;
    final String nonNullable = ConfigSetting().nullsafety.value ? '!' : '';
    int count = 0;
    String? result;
    while (temp is List) {
      if (temp.isNotEmpty) {
        temp = temp.first;
      } else {
        temp = null;
      }
      // delete List<
      typeString = typeString.substring('List<'.length);
      // delete >
      typeString = typeString.substring(0, typeString.length - 1);

      // next is array
      if (temp != null && temp is List) {
        if (count == 0) {
          result =
              " for (final dynamic item$count in asT<List<dynamic>>(${DartHelper.jsonRes}['$key'])$nonNullable) { if (item$count != null) {final $typeString items${count + 1} = ${typeString.substring('List'.length)}[]; {} $setName.add(items${count + 1}); }}";
        } else {
          result = result!.replaceAll('{}',
              " for (final dynamic item$count in asT<List<dynamic>>(item${count - 1})$nonNullable) { if (item$count != null) {final $typeString items${count + 1} = ${typeString.substring('List'.length)}[]; {} items$count.add(items${count + 1}); }}");
        }
      }

      // next is not array
      else {
        String item = 'item' + (count == 0 ? '' : count.toString());
        String addString = '';
        if (className != null) {
          item =
              '$className.fromJson(asT<Map<String,dynamic>>($item)$nonNullable)';
        } else {
          item = DartHelper.getUseAsT(baseType, item);
        }

        if (count == 0) {
          addString = '$setName.add($item); ';
          if (enableTryCatch) {
            addString = 'tryCatch(() { $addString }); ';
          }

          result =
              " for (final dynamic item in ${DartHelper.jsonRes}['$key']$nonNullable) { if (item != null) { $addString }}";
        } else {
          addString = 'items$count.add($item); ';

          if (enableTryCatch) {
            addString = 'tryCatch(() { $addString }); ';
          }

          result = result!.replaceAll('{}',
              ' for (final dynamic item$count in asT<List<dynamic>>(item${count - 1})$nonNullable) { if (item$count != null) {$addString}}');
        }
      }

      count++;
    }

    sb.writeLine(result);
    sb.writeLine('    }\n');

    return sb.toString();
  }

  @override
  List<Object?> get props => <Object?>[
        key,
        nullable,
        propertyAccessorType,
        type,
        uid,
      ];

  @override
  String toString() {
    return 'DartProperty($key, $value, $nullable)';
  }
}
