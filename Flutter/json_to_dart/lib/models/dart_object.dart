import 'package:get/get.dart';
import 'package:json_to_dart/main_controller.dart';
import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/utils/dart_helper.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:json_to_dart/utils/error_check/error_checker.dart';
import 'package:json_to_dart/utils/error_check/text_editing_controller.dart';
import 'package:json_to_dart/utils/my_string_buffer.dart';
import 'package:json_to_dart/utils/string_helper.dart';

import 'config.dart';
import 'dart_property.dart';

// ignore: must_be_immutable
class DartObject extends DartProperty {
  DartObject({
    String? uid,
    MapEntry<String, dynamic>? keyValuePair,
    required int depth,
    required bool nullable,
    DartObject? dartObject,
  }) : super(
          uid: uid!,
          keyValuePair: keyValuePair!,
          depth: depth,
          nullable: nullable,
          dartObject: dartObject,
        ) {
    classNameTextEditingController =
        ClassNameCheckerTextEditingController(this);

    properties = <DartProperty>[];
    objectKeys = <String, DartObject>{};
    _jObject = (this.keyValuePair.value as Map<String, dynamic>).map(
        (String key, dynamic value) => MapEntry<String, _InnerObject>(
            key,
            _InnerObject(
                data: value,
                type: DartHelper.converDartType(value.runtimeType),
                nullable: DartHelper.converNullable(value))));

    final String key = this.keyValuePair.key;
    className.value = correctName(
      upcaseCamelName(key),
      isClassName: true,
    );
    classNameTextEditingController.text = className.value;
    initializeProperties();
    updateNameByNamingConventionsType();

    Get.find<MainController>().allObjects.add(this);
    duplicateClassChecker = DuplicateClassChecker(this);
    errors.add(duplicateClassChecker);
    updateError(className);
  }

  Map<String, _InnerObject>? _jObject;
  Map<String, _InnerObject>? _mergeObject;

  Map<String, _InnerObject>? get jObject =>
      _mergeObject != null ? _mergeObject! : _jObject;

  late DuplicateClassChecker duplicateClassChecker;

  RxString className = ''.obs;

  late ClassNameCheckerTextEditingController classNameTextEditingController;
  late List<DartProperty> properties;

  late Map<String, DartObject> objectKeys;

  void decDepth() {
    depth -= 1;
    for (final DartObject obj in objectKeys.values) {
      obj.decDepth();
    }
  }

  void initializeProperties() {
    properties.clear();
    objectKeys.clear();
    if (jObject != null && jObject!.isNotEmpty) {
      for (final MapEntry<String, _InnerObject> item in jObject!.entries) {
        initializePropertyItem(item, depth);
      }
      orderPropeties();
    }
  }

  void initializePropertyItem(MapEntry<String, _InnerObject> item, int depth,
      {bool addProperty = true}) {
    if (item.value.data is Map &&
        (item.value.data as Map<String, dynamic>).isNotEmpty) {
      if (objectKeys.containsKey(item.key)) {
        final DartObject temp = objectKeys[item.key]!;
        temp.merge((item.value.data as Map<String, dynamic>).map(
            (String key, dynamic value) => MapEntry<String, _InnerObject>(
                key,
                _InnerObject(
                    data: value,
                    type: DartHelper.converDartType(value.runtimeType),
                    nullable: DartHelper.converNullable(value)))));
        objectKeys[item.key] = temp;
      } else {
        final DartObject temp = DartObject(
          uid: uid + '_' + item.key,
          keyValuePair: MapEntry<String, dynamic>(item.key, item.value.data),
          nullable: item.value.nullable,
          depth: depth + 1,
          dartObject: this,
        );
        if (addProperty) {
          properties.add(temp);
        }
        objectKeys[item.key] = temp;
      }
    } else if (item.value.data is List) {
      if (addProperty) {
        properties.add(DartProperty(
            uid: uid,
            keyValuePair: MapEntry<String, dynamic>(item.key, item.value.data),
            nullable: item.value.nullable,
            depth: depth,
            dartObject: this));
      }
      final List<dynamic> array = item.value.data as List<dynamic>;
      if (array.isNotEmpty) {
        int count = ConfigSetting().traverseArrayCount.value;
        if (count == 99) {
          count = array.length;
        }
        final Iterable<dynamic> cutArray = array.take(count);
        for (final dynamic arrayItem in cutArray) {
          initializePropertyItem(
              MapEntry<String, _InnerObject>(
                  item.key,
                  _InnerObject(
                      data: arrayItem,
                      type: DartHelper.converDartType(arrayItem.runtimeType),
                      nullable: DartHelper.converNullable(value) &&
                          ConfigSetting().smartNullable)),
              depth,
              addProperty: false);
        }
      }
    } else {
      if (addProperty) {
        properties.add(DartProperty(
          uid: uid,
          keyValuePair: MapEntry<String, dynamic>(item.key, item.value.data),
          nullable: item.value.nullable,
          depth: depth,
          dartObject: this,
        ));
      }
    }
  }

  void merge(Map<String, _InnerObject>? other) {
    bool needInitialize = false;
    if (_jObject != null) {
      _mergeObject ??= <String, _InnerObject>{};

      for (final MapEntry<String, _InnerObject> item in _jObject!.entries) {
        if (!_mergeObject!.containsKey(item.key)) {
          needInitialize = true;
          _mergeObject![item.key] = item.value;
        }
      }

      if (other != null) {
        _mergeObject ??= <String, _InnerObject>{};

        if (ConfigSetting().smartNullable) {
          for (final MapEntry<String, _InnerObject> existObject
              in _mergeObject!.entries) {
            if (!other.containsKey(existObject.key)) {
              final _InnerObject newObject = _InnerObject(
                  data: existObject.value.data,
                  type: existObject.value.type,
                  nullable: true);
              _mergeObject![existObject.key] = newObject;
              needInitialize = true;
            }
          }
        }

        for (final MapEntry<String, _InnerObject> item in other.entries) {
          if (!_mergeObject!.containsKey(item.key)) {
            needInitialize = true;
            _mergeObject![item.key] = _InnerObject(
                data: item.value.data, type: item.value.type, nullable: true);
          } else {
            _InnerObject existObject = _mergeObject![item.key]!;
            if ((existObject.isNull && !item.value.isNull) ||
                (!existObject.isNull && item.value.isNull) ||
                existObject.nullable != item.value.nullable) {
              existObject = _InnerObject(
                  data: item.value.data ?? existObject.data,
                  type: item.value.type != DartType.Null
                      ? item.value.type
                      : existObject.type,
                  nullable: (existObject.nullable || item.value.nullable) &&
                      ConfigSetting().smartNullable);
              _mergeObject![item.key] = existObject;
              needInitialize = true;
            } else if (existObject.isList &&
                item.value.isList &&
                ((existObject.isEmpty || item.value.isEmpty) ||
                    // make sure Object will be merge
                    (existObject.isObject || item.value.isObject))) {
              existObject = _InnerObject(
                data: (item.value.data as List<dynamic>)
                  ..addAll(existObject.data as List<dynamic>),
                type: item.value.type,
                nullable: false,
              );
              _mergeObject![item.key] = existObject;
              needInitialize = true;
            }
          }
        }
        if (needInitialize) {
          initializeProperties();
        }
      }
    }
  }

  @override
  void updateNameByNamingConventionsType() {
    super.updateNameByNamingConventionsType();

    for (final DartProperty item in properties) {
      item.updateNameByNamingConventionsType();
    }

    for (final MapEntry<String, DartObject> item in objectKeys.entries) {
      item.value.updateNameByNamingConventionsType();
    }
  }

  @override
  void updatePropertyAccessorType() {
    super.updatePropertyAccessorType();

    for (final DartProperty item in properties) {
      item.updatePropertyAccessorType();
    }

    for (final MapEntry<String, DartObject> item in objectKeys.entries) {
      item.value.updatePropertyAccessorType();
    }
  }

  @override
  void updateNullable(bool nullable) {
    super.updateNullable(nullable);
    for (final DartProperty item in properties) {
      item.updateNullable(nullable);
    }

    for (final MapEntry<String, DartObject> item in objectKeys.entries) {
      item.value.updateNullable(nullable);
    }
  }

  @override
  String getTypeString({String? className}) {
    return this.className.value;
  }

  void orderPropeties() {
    final PropertyNameSortingType sortingType =
        ConfigSetting().propertyNameSortingType.value;
    if (sortingType != PropertyNameSortingType.none) {
      if (sortingType == PropertyNameSortingType.ascending) {
        properties.sort((DartProperty left, DartProperty right) =>
            left.name.compareTo(right.name.value));
      } else {
        properties.sort((DartProperty left, DartProperty right) =>
            right.name.compareTo(left.name.value));
      }
    }

    if (jObject != null) {
      for (final MapEntry<String, DartObject> item in objectKeys.entries) {
        item.value.orderPropeties();
      }
    }
  }

  @override
  String toString() {
    final MainController controller = Get.find();
    if (controller.printedObjects.contains(this)) {
      return '';
    }
    controller.printedObjects.add(this);

    orderPropeties();

    final MyStringBuffer sb = MyStringBuffer();

    sb.writeLine(
        stringFormat(DartHelper.classHeader, <String>[className.value]));

    if (properties.isNotEmpty) {
      final MyStringBuffer factorySb = MyStringBuffer();
      final MyStringBuffer factorySb1 = MyStringBuffer();
      final MyStringBuffer propertySb = MyStringBuffer();
      //StringBuffer propertySb1 = StringBuffer();
      final MyStringBuffer fromJsonSb = MyStringBuffer();
      //Array
      final MyStringBuffer fromJsonSb1 = MyStringBuffer();
      final MyStringBuffer toJsonSb = MyStringBuffer();

      final MyStringBuffer copySb = MyStringBuffer();

      final bool isAllFinalProperties = !properties.any(
          (DartProperty element) =>
              element.propertyAccessorType.value !=
              PropertyAccessorType.final_);

      factorySb.writeLine(stringFormat(DartHelper.factoryStringHeader,
          <String>['${isAllFinalProperties ? 'const' : ''} $className']));

      toJsonSb.writeLine(DartHelper.toJsonHeader);

      for (final DartProperty item in properties) {
        final String lowName =
            item.name.substring(0, 1).toLowerCase() + item.name.substring(1);
        final String name = item.name.value;
        String? className;
        String? typeString;
        final String setName = DartHelper.getSetPropertyString(item);
        String setString = '';
        final String fss = DartHelper.factorySetString(
          item.propertyAccessorType.value,
          (!ConfigSetting().nullsafety) ||
              (ConfigSetting().nullsafety && item.nullable),
        );
        final bool isGetSet = fss.startsWith('{');
        String copyProperty = item.name.value;

        if (item is DartObject) {
          className = item.className.value;

          setString = stringFormat(DartHelper.setObjectProperty, <String>[
            item.name.value,
            item.key,
            className,
            if (ConfigSetting().nullsafety && item.nullable)
              '${DartHelper.jsonRes}[\'${item.key}\']==null?null:'
            else
              '',
            if (ConfigSetting().nullsafety) '!' else ''
          ]);
          typeString = className;
          if (ConfigSetting().nullsafety && item.nullable) {
            typeString += '?';
          }

          if (ConfigSetting().addCopyMethod.value) {
            if (!ConfigSetting().nullsafety || item.nullable) {
              copyProperty += '?';
            }
            copyProperty += '.copy()';
          }
        } else if (item.value is List) {
          if (objectKeys.containsKey(item.key)) {
            className = objectKeys[item.key]!.className.value;
          }
          typeString = item.getTypeString(className: className);

          typeString = typeString.replaceAll('?', '');

          fromJsonSb1.writeLine(item.getArraySetPropertyString(
            lowName,
            typeString,
            className: className,
            baseType: item
                .getBaseTypeString(className: className)
                .replaceAll('?', ''),
          ));

          setString = ' ${item.name}:$lowName';

          if (ConfigSetting().nullsafety) {
            if (item.nullable) {
              typeString += '?';
            } else {
              setString += '!';
            }
          }
          setString += ',';
          if (ConfigSetting().addCopyMethod.value)
            copyProperty = item.getListCopy(className: className);
        } else {
          setString = DartHelper.setProperty(
              item.name.value, item, this.className.value);
          typeString = DartHelper.getDartTypeString(item.type.value, item);
        }

        if (isGetSet) {
          factorySb.writeLine(stringFormat(fss, <String>[typeString, lowName]));
          if (factorySb1.length == 0) {
            factorySb1.write('}):');
          } else {
            factorySb1.write(',');
          }
          factorySb1.write('$setName=$lowName');
        } else {
          factorySb.writeLine(stringFormat(fss, <String>[item.name.value]));
        }

        propertySb.writeLine(stringFormat(
            DartHelper.propertyS(item.propertyAccessorType.value),
            <String>[typeString, name, lowName]));
        fromJsonSb.writeLine(setString);

        // String setNameTemp = setName;

        // if (className != null) {
        //   String toJson = '=> e.toJson()';
        //   dynamic value = item.value;
        //   String typeString = className;
        //   while (value is List) {
        //     toJson = '=> e.map(($typeString e) $toJson)';
        //     typeString = 'List<$typeString>';
        //     if (value.isNotEmpty) {
        //       value = value.first;
        //     } else {
        //       break;
        //     }
        //   }
        //   toJson = toJson.replaceFirst('=>', '');
        //   toJson = toJson.replaceFirst('e', '');
        //   toJson = toJson.trim();

        //   final bool nonNullAble = ConfigSetting().nullsafety && !item.nullable;
        //   setNameTemp += '${nonNullAble ? '' : '?'}$toJson';
        // }

        toJsonSb.writeLine(stringFormat(DartHelper.toJsonSetString, <String>[
          item.key,
          setName,
        ]));
        if (ConfigSetting().addCopyMethod.value)
          copySb.writeLine('${item.name}:$copyProperty,');
      }

      if (factorySb1.length == 0) {
        factorySb.writeLine(DartHelper.factoryStringFooter);
      } else {
        factorySb1.write(';');
        factorySb.write(factorySb1.toString());
      }

      String fromJson = '';
      if (fromJsonSb1.length != 0) {
        fromJson = stringFormat(
                ConfigSetting().nullsafety
                    ? DartHelper.fromJsonHeader1NullSafety
                    : DartHelper.fromJsonHeader1,
                <String>[className.value]) +
            fromJsonSb1.toString() +
            stringFormat(DartHelper.fromJsonFooter1,
                <String>[className.value, fromJsonSb.toString()]);
      } else {
        fromJson = stringFormat(
                ConfigSetting().nullsafety
                    ? DartHelper.fromJsonHeaderNullSafety
                    : DartHelper.fromJsonHeader,
                <String>[className.value]) +
            fromJsonSb.toString() +
            DartHelper.fromJsonFooter;
      }

      //fromJsonSb.AppendLine(DartHelper.FromJsonFooter);

      toJsonSb.writeLine(DartHelper.toJsonFooter);
      sb.writeLine(factorySb.toString());
      sb.writeLine(fromJson);
      sb.writeLine(propertySb.toString());
      sb.writeLine(DartHelper.classToString);
      sb.writeLine(toJsonSb.toString());
      if (ConfigSetting().addCopyMethod.value) {
        sb.writeLine(stringFormat(DartHelper.copyMethodString, <String>[
          className.value,
          copySb.toString(),
        ]));
      }
      // sb.writeLine(stringFormat(DartHelper.classToClone,
      //     <String>[className, if (ConfigSetting().nullsafety) '!' else '']));
    }

    sb.writeLine(DartHelper.classFooter);

    for (final MapEntry<String, DartObject> item in objectKeys.entries) {
      sb.writeLine(item.value.toString());
    }

    return sb.toString();
  }

  @override
  List<Object?> get props => <Object?>[
        key,
        uid,
      ];

  RxSet<String> classError = <String>{}.obs;

  bool get hasClassError => classError.isNotEmpty;
}

class _InnerObject {
  _InnerObject({
    required this.data,
    required this.type,
    required this.nullable,
  });
  final dynamic data;
  final DartType type;
  final bool nullable;

  bool get isList => data is List;
  bool get isEmpty => isList && (data as List<dynamic>).isEmpty;
  bool get isNull => type.isNull;
  bool get isObject => type == DartType.Object;
}

class CheckError implements Exception {
  CheckError(this.msg);
  final String msg;
}
