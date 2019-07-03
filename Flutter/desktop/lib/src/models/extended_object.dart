import 'package:json_to_dart/src/utils/config_helper.dart';
import 'package:json_to_dart/src/utils/dart_helper.dart';
import 'package:json_to_dart/src/utils/enums.dart';
import 'package:json_to_dart/src/utils/my_string_buffer.dart';
import 'package:json_to_dart/src/utils/string_helper.dart';

import 'extended_property.dart';

class ExtendedObject extends ExtendedProperty {
  Map _jObject;
  Map _mergeObject;
  Map get jObject => _mergeObject != null ? _mergeObject : _jObject;

  String _className;

  String get className => _className;

  set className(String className) {
    _className = className;
  }

  List<ExtendedProperty> properties;

  Map<String, ExtendedObject> objectKeys;

  ExtendedObject(
      {String uid, MapEntry<String, dynamic> keyValuePair, int depth})
      : super(uid: uid, keyValuePair: keyValuePair, depth: depth) {
    properties = List<ExtendedProperty>();
    objectKeys = Map<String, ExtendedObject>();
    this._jObject = keyValuePair.value as Map;

    var key = keyValuePair.key;
    var className = key.substring(0, 1).toUpperCase() + key.substring(1);
    this.className = className;
    initializeProperties();
    updateNameByNamingConventionsType();
  }

  void initializeProperties() {
    properties.clear();
    objectKeys.clear();
    if (jObject.isNotEmpty) {
      for (var item in jObject.entries) {
        initializePropertyItem(item, depth);
      }
      orderPropeties();
    }
  }

  void initializePropertyItem(MapEntry<String, dynamic> item, int depth,
      {bool addProperty = true}) {
    if (item.value is Map && (item.value as Map).isNotEmpty) {
      if (objectKeys.containsKey(item.key)) {
        var temp = objectKeys[item.key];
        temp.merge(item.value as Map);
        objectKeys[item.key] = temp;
      } else {
        var temp = new ExtendedObject(
            uid: uid + "_" + item.key, keyValuePair: item, depth: depth + 1);
        if (addProperty) properties.add(temp);
        objectKeys[item.key] = temp;
      }
    } else if (item.value is List) {
      if (addProperty) {
        properties
            .add(ExtendedProperty(uid: uid, keyValuePair: item, depth: depth));
      }
      var array = item.value as List;
      if (array.isNotEmpty) {
        var count = ConfigHelper().config.traverseArrayCount;
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

  void merge(Map other) {
    bool needInitialize = false;
    if (_jObject != null) {
      if (_mergeObject == null) {
        _mergeObject = Map();
      }

      for (var item in _jObject.entries) {
        if (!_mergeObject.containsKey(item.key)) {
          needInitialize = true;
        }
      }

      if (other != null) {
        if (_mergeObject == null) {
          _mergeObject = Map();
        }

        for (var item in other.entries) {
          if (!_mergeObject.containsKey(item.key)) {
            needInitialize = true;
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
    if (properties != null) {
      for (var item in properties) {
        item.updateNameByNamingConventionsType();
      }
    }
  }

  @override
  void updatePropertyAccessorType() {
    super.updatePropertyAccessorType();
    if (properties != null) {
      for (var item in properties) {
        item.updatePropertyAccessorType();
      }
    }
    if (objectKeys != null) {
      for (var item in objectKeys.entries) {
        item.value.updatePropertyAccessorType();
      }
    }
  }

  @override
  String getTypeString({String className}) {
    return this.className;
  }

  void orderPropeties() {
    if (jObject.entries.length > 0) {
      var sortingType = ConfigHelper().config.propertyNameSortingType;
      if (sortingType != PropertyNameSortingType.none) {
        if (sortingType == PropertyNameSortingType.ascending) {
          properties.sort((left, right) => left.name.compareTo(right.name));
        } else {
          properties.sort((left, right) => left.name.compareTo(right.name));
        }
      }

      if (objectKeys != null) {
        for (var item in objectKeys.entries) {
          item.value.orderPropeties();
        }
      }
    }
  }

  @override
  String toString() {
    orderPropeties();

    MyStringBuffer sb = MyStringBuffer();

    sb.writeLine(
        stringFormat(DartHelper.classHeader, <dynamic>[this.className]));

    if (properties.length > 0) {
      MyStringBuffer factorySb = MyStringBuffer();
      MyStringBuffer factorySb1 = MyStringBuffer();
      MyStringBuffer propertySb = MyStringBuffer();
      //StringBuffer propertySb1 = StringBuffer();
      MyStringBuffer fromJsonSb = MyStringBuffer();
      //Array
      MyStringBuffer fromJsonSb1 = MyStringBuffer();
      MyStringBuffer toJsonSb = MyStringBuffer();

      factorySb.writeLine(stringFormat(
          DartHelper.factoryStringHeader, <dynamic>[this.className]));

      toJsonSb.writeLine(DartHelper.toJsonHeader);

      for (var item in properties) {
        var lowName =
            item.name.substring(0, 1).toLowerCase() + item.name.substring(1);
        var name = item.name;
        String className;
        String typeString;
        var setName = DartHelper.getSetPropertyString(item);
        var setString = "";
        var fss = DartHelper.factorySetString(item.propertyAccessorType);
        bool isGetSet = fss.startsWith("{");

        if (item is ExtendedObject) {
          className = item.className;
          setString = stringFormat(DartHelper.setObjectProperty,
              <dynamic>[lowName, item.key, className]);
          typeString = className;
        } else if (item.value.runtimeType == List) {
          if (objectKeys.containsKey(item.key)) {
            className = objectKeys[item.key].className;
          }
          typeString = item.getTypeString(className: className);

          fromJsonSb1.writeLine(item.getArraySetPropertyString(
              lowName, typeString,
              className: className));

          setString = " ${(isGetSet ? lowName : item.name)}:$lowName,";
        } else {
          setString = DartHelper.setProperty(lowName, item, className);
          typeString = DartHelper.getDartTypeString(item.type);
        }

        if (isGetSet) {
          factorySb
              .writeLine(stringFormat(fss, <dynamic>[typeString, lowName]));
          if (factorySb1.length == 0) {
            factorySb1.write("}):");
          } else {
            factorySb1.write(",");
          }
          factorySb1.write("$setName=$lowName");
        } else {
          factorySb.writeLine(stringFormat(fss, <dynamic>[item.name]));
        }

        propertySb.writeLine(stringFormat(
            DartHelper.propertyS(item.propertyAccessorType),
            <dynamic>[typeString, name, lowName]));
        fromJsonSb.writeLine(setString);
        toJsonSb.writeLine(stringFormat(
            DartHelper.toJsonSetString, <dynamic>[item.key, setName]));
      }

      if (factorySb1.length == 0) {
        factorySb.writeLine(DartHelper.factoryStringFooter);
      } else {
        factorySb1.write(";");
        factorySb.write(factorySb1.toString());
      }

      var fromJson = "";
      if (fromJsonSb1.length != 0) {
        fromJson = stringFormat(
                DartHelper.fromJsonHeader1, <dynamic>[this.className]) +
            fromJsonSb1.toString() +
            stringFormat(DartHelper.fromJsonFooter1,
                <dynamic>[this.className, fromJsonSb.toString()]);
      } else {
        fromJson =
            stringFormat(DartHelper.fromJsonHeader, <dynamic>[this.className]) +
                fromJsonSb.toString() +
                DartHelper.fromJsonFooter;
      }

      //fromJsonSb.AppendLine(DartHelper.FromJsonFooter);

      toJsonSb.writeLine(DartHelper.toJsonFooter);

      sb.writeLine(propertySb.toString());

      sb.writeLine(factorySb.toString());

      sb.writeLine(fromJson);

      sb.writeLine(toJsonSb.toString());

      sb.writeLine(DartHelper.classToString);
    }

    sb.writeLine(DartHelper.classFooter);

    for (var item in objectKeys.entries) {
      sb.writeLine(item.value.toString());
    }

    return sb.toString();
  }
}
