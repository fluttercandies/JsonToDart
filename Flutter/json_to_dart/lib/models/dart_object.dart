import 'dart:async';
import 'package:json_to_dart/localizations/app_localizations.dart';
import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/utils/dart_helper.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:json_to_dart/utils/my_string_buffer.dart';
import 'package:json_to_dart/utils/string_helper.dart';

import 'config.dart';
import 'dart_property.dart';

List<DartObject> printedObjects = <DartObject>[];

// ignore: must_be_immutable
class DartObject extends DartProperty {
  DartObject({
    String? uid,
    MapEntry<String, dynamic>? keyValuePair,
    required int depth,
    DartObject? source,
  }) : super(
            uid: source?.uid ?? uid!,
            keyValuePair: source?.keyValuePair ?? keyValuePair!,
            depth: source?.depth ?? depth) {
    if (source != null) {
      properties = source.properties;
      objectKeys = source.objectKeys;
      _jObject = source.keyValuePair.value as Map<String, dynamic>?;
      className = source.className;
    } else {
      properties = <DartProperty>[];
      objectKeys = <String, DartObject>{};
      _jObject = this.keyValuePair.value as Map<String, dynamic>?;

      final String key = this.keyValuePair.key;
      final String className =
          key.substring(0, 1).toUpperCase() + key.substring(1);
      this.className = className;
      initializeProperties();
      updateNameByNamingConventionsType();
    }
  }

  Map<String, dynamic>? _jObject;
  Map<String, dynamic>? _mergeObject;
  Map<String, dynamic>? get jObject =>
      _mergeObject != null ? _mergeObject! : _jObject;

  String _className = '';

  String get className => _className;

  set className(String className) {
    _className = className;
    if (!rebuildName.isClosed) {
      rebuildName.sink.add(className);
    }
  }

  StreamController<String> rebuildName = StreamController<String>.broadcast();

  late List<DartProperty> properties;

  late Map<String, DartObject> objectKeys;

  void close() {
    rebuildName.close();
  }

  void initializeProperties() {
    properties.clear();
    objectKeys.clear();
    if (jObject != null && jObject!.isNotEmpty) {
      for (final MapEntry<String, dynamic> item in jObject!.entries) {
        initializePropertyItem(item, depth);
      }
      orderPropeties();
    }
  }

  void initializePropertyItem(MapEntry<String, dynamic> item, int depth,
      {bool addProperty = true}) {
    if (item.value is Map && (item.value as Map<String, dynamic>).isNotEmpty) {
      if (objectKeys.containsKey(item.key)) {
        final DartObject temp = objectKeys[item.key]!;
        temp.merge(item.value as Map<String, dynamic>);
        objectKeys[item.key] = temp;
      } else {
        final DartObject temp = DartObject(
            uid: uid + '_' + item.key, keyValuePair: item, depth: depth + 1);
        if (addProperty) {
          properties.add(temp);
        }
        objectKeys[item.key] = temp;
      }
    } else if (item.value is List) {
      if (addProperty) {
        properties
            .add(DartProperty(uid: uid, keyValuePair: item, depth: depth));
      }
      final List<dynamic> array = item.value as List<dynamic>;
      if (array.isNotEmpty) {
        int count = ConfigSetting().traverseArrayCount;
        if (count == 99) {
          count = array.length;
        }
        for (int i = 0; i < array.length && i < count; i++) {
          initializePropertyItem(
              MapEntry<String, dynamic>(item.key, array[i]), depth,
              addProperty: false);
        }
      }
    } else {
      if (addProperty) {
        properties
            .add(DartProperty(uid: uid, keyValuePair: item, depth: depth));
      }
    }
  }

  void merge(Map<String, dynamic>? other) {
    bool needInitialize = false;
    if (_jObject != null) {
      _mergeObject ??= <String, dynamic>{};

      for (final MapEntry<String, dynamic> item in _jObject!.entries) {
        if (!_mergeObject!.containsKey(item.key)) {
          needInitialize = true;
          _mergeObject![item.key] = item.value;
        }
      }

      if (other != null) {
        _mergeObject ??= <String, dynamic>{};

        for (final MapEntry<String, dynamic> item in other.entries) {
          if (!_mergeObject!.containsKey(item.key)) {
            needInitialize = true;
            _mergeObject![item.key] = item.value;
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
    return this.className;
  }

  void orderPropeties() {
    final PropertyNameSortingType sortingType =
        ConfigSetting().propertyNameSortingType;
    if (sortingType != PropertyNameSortingType.none) {
      if (sortingType == PropertyNameSortingType.ascending) {
        properties.sort((DartProperty left, DartProperty right) =>
            left.name.compareTo(right.name));
      } else {
        properties.sort((DartProperty left, DartProperty right) =>
            right.name.compareTo(left.name));
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
    if (printedObjects.contains(this)) {
      return '';
    }
    printedObjects.add(this);

    orderPropeties();

    final MyStringBuffer sb = MyStringBuffer();

    sb.writeLine(stringFormat(DartHelper.classHeader, <String>[className]));

    if (properties.isNotEmpty) {
      final MyStringBuffer factorySb = MyStringBuffer();
      final MyStringBuffer factorySb1 = MyStringBuffer();
      final MyStringBuffer propertySb = MyStringBuffer();
      //StringBuffer propertySb1 = StringBuffer();
      final MyStringBuffer fromJsonSb = MyStringBuffer();
      //Array
      final MyStringBuffer fromJsonSb1 = MyStringBuffer();
      final MyStringBuffer toJsonSb = MyStringBuffer();

      factorySb.writeLine(
          stringFormat(DartHelper.factoryStringHeader, <String>[className]));

      toJsonSb.writeLine(DartHelper.toJsonHeader);

      for (final DartProperty item in properties) {
        final String lowName =
            item.name.substring(0, 1).toLowerCase() + item.name.substring(1);
        final String name = item.name;
        String? className;
        String? typeString;
        final String setName = DartHelper.getSetPropertyString(item);
        String setString = '';
        final String fss = DartHelper.factorySetString(
          item.propertyAccessorType,
          (!ConfigSetting().nullsafety) ||
              (ConfigSetting().nullsafety && item.nullable),
        );
        final bool isGetSet = fss.startsWith('{');
        if (item is DartObject) {
          className = item.className;

          setString = stringFormat(DartHelper.setObjectProperty, <String>[
            item.name,
            item.key,
            className,
            if (ConfigSetting().nullsafety && item.nullable)
              'jsonRes[\'${item.key}\']==null?null:'
            else
              '',
            if (ConfigSetting().nullsafety) '!' else ''
          ]);
          typeString = className;
          if (ConfigSetting().nullsafety && item.nullable) {
            typeString += '?';
          }
        } else if (item.value is List) {
          if (objectKeys.containsKey(item.key)) {
            className = objectKeys[item.key]!.className;
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
        } else {
          setString = DartHelper.setProperty(item.name, item, this.className);
          typeString = DartHelper.getDartTypeString(item.type, item);
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
          factorySb.writeLine(stringFormat(fss, <String>[item.name]));
        }

        propertySb.writeLine(stringFormat(
            DartHelper.propertyS(item.propertyAccessorType),
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
                <String>[className]) +
            fromJsonSb1.toString() +
            stringFormat(DartHelper.fromJsonFooter1,
                <String>[className, fromJsonSb.toString()]);
      } else {
        fromJson = stringFormat(
                ConfigSetting().nullsafety
                    ? DartHelper.fromJsonHeaderNullSafety
                    : DartHelper.fromJsonHeader,
                <String>[className]) +
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
      sb.writeLine(stringFormat(DartHelper.classToClone,
          <String>[className, if (ConfigSetting().nullsafety) '!' else '']));
    }

    sb.writeLine(DartHelper.classFooter);

    for (final MapEntry<String, DartObject> item in objectKeys.entries) {
      sb.writeLine(item.value.toString());
    }

    return sb.toString();
  }

  String? hasEmptyProperties() {
    final AppLocalizations appLocalizations = AppLocalizations.instance;
    if (isNullOrWhiteSpace(className)) {
      return appLocalizations.classNameAssert(uid);
    }

    for (final DartProperty item in properties) {
      if (item is DartObject) {
        if (depth > 0 &&
            !item.uid.endsWith('_Array') &&
            isNullOrWhiteSpace(item.name)) {
          return appLocalizations.propertyNameAssert(item.uid);
        }
      } else if (isNullOrWhiteSpace(item.name)) {
        return appLocalizations.propertyNameAssert(item.uid);
      }
    }

    for (final MapEntry<String, DartObject> item in objectKeys.entries) {
      final String? msg = item.value.hasEmptyProperties();
      if (msg != null) {
        return msg;
      }
    }
    return null;
  }

  DartObject copy() {
    return DartObject(source: this, depth: depth);
  }

  @override
  List<Object?> get props => <Object?>[
        className,
        properties,
      ];
}
