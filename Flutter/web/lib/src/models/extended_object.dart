import 'extended_property.dart';

class ExtendedObject extends ExtendedProperty {
  Map _jObject;
  Map _mergeObject;
  Map get JObject => _mergeObject != null ? _mergeObject : _jObject;

  String _className;

  String get className => _className;

  set className(String className) {
    _className = className;
  }

  List<ExtendedProperty> properties;

  Map<String, ExtendedObject> objectKeys;

  ExtendedObject({String uid, MapEntry<String, Map> keyValuePair, int depth})
      : super(uid: uid, keyValuePair: keyValuePair, depth: depth) {
    properties = List<ExtendedProperty>();
    objectKeys = Map<String, ExtendedObject>();
    this._jObject = keyValuePair.value;

    var key = keyValuePair.key;
    var className = key.substring(0, 1).toUpperCase() + key.substring(1);
    this.className = className;
    initializeProperties();
    updateNameByNamingConventionsType();
  }

  void initializeProperties() {
    properties.clear();
    objectKeys.clear();
    if (JObject.isNotEmpty) {
      for (var item in JObject.entries) {
        initializePropertyItem(item, depth);
      }
      // OrderPropeties();
    }
  }

  void initializePropertyItem(MapEntry<String, dynamic> item, int depth,
      {bool addProperty = true}) {
    if (item.value is Map && (item.value as Map).isNotEmpty) {
      if (objectKeys.containsKey(item.key)) {
        var temp = objectKeys[item.key];
        temp.Merge(item.value as Map);
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
        // var count = ConfigHelper.Instance.Config.TraverseArrayCount;
        // if (count == 99) {
        //   count = array.Count();
        // }
        var count = 1;
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

  void Merge(Map other) {
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
    for (var item in properties) {
      item.updateNameByNamingConventionsType();
    }
  }

  @override
  void updatePropertyAccessorType() {
    super.updatePropertyAccessorType();
     for (var item in properties) {
      item.updatePropertyAccessorType();
    }
    for (var item in objectKeys.entries) {
      item.value.updatePropertyAccessorType();
    }
  }
}
