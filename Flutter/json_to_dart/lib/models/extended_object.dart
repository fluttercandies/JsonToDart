import 'dart:async';
import 'package:json_to_dart/localizations/app_localizations.dart';
import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/utils/dart_helper.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:json_to_dart/utils/my_string_buffer.dart';
import 'package:json_to_dart/utils/string_helper.dart';

import 'extended_property.dart';

class ExtendedObject extends ExtendedProperty {
  ExtendedObject({
    String? uid,
    MapEntry<String, dynamic>? keyValuePair,
    required int depth,
    ExtendedObject? source,
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
      properties = <ExtendedProperty>[];
      objectKeys = <String, ExtendedObject>{};
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

  late List<ExtendedProperty> properties;

  late Map<String, ExtendedObject> objectKeys;

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
        final ExtendedObject temp = objectKeys[item.key]!;
        temp.merge(item.value as Map<String, dynamic>);
        objectKeys[item.key] = temp;
      } else {
        final ExtendedObject temp = ExtendedObject(
            uid: uid + '_' + item.key, keyValuePair: item, depth: depth + 1);
        if (addProperty) {
          properties.add(temp);
        }
        objectKeys[item.key] = temp;
      }
    } else if (item.value is List) {
      if (addProperty) {
        properties
            .add(ExtendedProperty(uid: uid, keyValuePair: item, depth: depth));
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
            .add(ExtendedProperty(uid: uid, keyValuePair: item, depth: depth));
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

    for (final ExtendedProperty item in properties) {
      item.updateNameByNamingConventionsType();
    }

    for (final MapEntry<String, ExtendedObject> item in objectKeys.entries) {
      item.value.updateNameByNamingConventionsType();
    }
  }

  @override
  void updatePropertyAccessorType() {
    super.updatePropertyAccessorType();

    for (final ExtendedProperty item in properties) {
      item.updatePropertyAccessorType();
    }

    for (final MapEntry<String, ExtendedObject> item in objectKeys.entries) {
      item.value.updatePropertyAccessorType();
    }
  }

  @override
  void updateNullable(bool nullable) {
    super.updateNullable(nullable);
    for (final ExtendedProperty item in properties) {
      item.updateNullable(nullable);
    }

    for (final MapEntry<String, ExtendedObject> item in objectKeys.entries) {
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
        properties.sort((ExtendedProperty left, ExtendedProperty right) =>
            left.name.compareTo(right.name));
      } else {
        properties.sort((ExtendedProperty left, ExtendedProperty right) =>
            right.name.compareTo(left.name));
      }
    }

    if (jObject != null) {
      for (final MapEntry<String, ExtendedObject> item in objectKeys.entries) {
        item.value.orderPropeties();
      }
    }
  }

  @override
  String toString() {
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

      for (final ExtendedProperty item in properties) {
        final String lowName =
            item.name.substring(0, 1).toLowerCase() + item.name.substring(1);
        final String name = item.name;
        String? className;
        String? typeString;
        final String setName = DartHelper.getSetPropertyString(item);
        String setString = '';
        final String fss =
            DartHelper.factorySetString(item.propertyAccessorType);
        final bool isGetSet = fss.startsWith('{');

        if (item is ExtendedObject) {
          className = item.className;
          setString = stringFormat(DartHelper.setObjectProperty,
              <String>[item.name, item.key, className]);
          typeString = className;
        } else if (item.value is List) {
          if (objectKeys.containsKey(item.key)) {
            className = objectKeys[item.key]!.className;
          }
          typeString = item.getTypeString(className: className);

          fromJsonSb1.writeLine(item.getArraySetPropertyString(
              lowName, typeString,
              className: className,
              baseType: item.getBaseTypeString(className: className)));

          setString = ' ${item.name}:$lowName,';
        } else {
          setString = DartHelper.setProperty(item.name, item, this.className);
          typeString = DartHelper.getDartTypeString(item.type);
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
        toJsonSb.writeLine(stringFormat(
            DartHelper.toJsonSetString, <String>[item.key, setName]));
      }

      if (factorySb1.length == 0) {
        factorySb.writeLine(DartHelper.factoryStringFooter);
      } else {
        factorySb1.write(';');
        factorySb.write(factorySb1.toString());
      }

      String fromJson = '';
      if (fromJsonSb1.length != 0) {
        fromJson =
            stringFormat(DartHelper.fromJsonHeader1, <String>[className]) +
                fromJsonSb1.toString() +
                stringFormat(DartHelper.fromJsonFooter1,
                    <String>[className, fromJsonSb.toString()]);
      } else {
        fromJson =
            stringFormat(DartHelper.fromJsonHeader, <String>[className]) +
                fromJsonSb.toString() +
                DartHelper.fromJsonFooter;
      }

      //fromJsonSb.AppendLine(DartHelper.FromJsonFooter);

      toJsonSb.writeLine(DartHelper.toJsonFooter);
      sb.writeLine(factorySb.toString());
      sb.writeLine(fromJson);
      sb.writeLine(propertySb.toString());

      sb.writeLine(toJsonSb.toString());

      sb.writeLine(DartHelper.classToString);
    }

    sb.writeLine(DartHelper.classFooter);

    for (final MapEntry<String, ExtendedObject> item in objectKeys.entries) {
      sb.writeLine(item.value.toString());
    }

    return sb.toString();
  }

  String? hasEmptyProperties() {
    final AppLocalizations appLocalizations = AppLocalizations.instance;
    if (isNullOrWhiteSpace(className)) {
      return appLocalizations.classNameAssert(uid);
    }

    for (final ExtendedProperty item in properties) {
      if (item is ExtendedObject) {
        if (depth > 0 &&
            !item.uid.endsWith('_Array') &&
            isNullOrWhiteSpace(item.name)) {
          return appLocalizations.propertyNameAssert(item.uid);
        }
      } else if (isNullOrWhiteSpace(item.name)) {
        return appLocalizations.propertyNameAssert(item.uid);
      }
    }

    for (final MapEntry<String, ExtendedObject> item in objectKeys.entries) {
      final String? msg = item.value.hasEmptyProperties();
      if (msg != null) {
        return msg;
      }
    }
    return null;
  }

  ExtendedObject copy() {
    return ExtendedObject(source: this, depth: depth);
  }
}
