import 'package:json_to_dart_web/src/utils/config_helper.dart';
import 'package:json_to_dart_web/src/utils/enums.dart';
import 'package:json_to_dart_web/src/utils/camel_under_score_converter.dart';

class ExtendedProperty {
  final String uid;
  final int depth;
  final String key;
  final dynamic value;
  final MapEntry<String, dynamic> keyValuePair;

  String _name;
  String get name => _name;
  set name(value) {
    _name = value;
  }

  PropertyAccessorType _propertyAccessorType;

  PropertyAccessorType get propertyAccessorType => _propertyAccessorType;

  set propertyAccessorType(PropertyAccessorType propertyAccessorType) {
    _propertyAccessorType = propertyAccessorType;
  }

  ExtendedProperty({String uid, this.depth, this.keyValuePair})
      : key = keyValuePair.key,
        uid = uid + "_" + keyValuePair.key,
        value = keyValuePair.value,
        _name = keyValuePair.key,
        _propertyAccessorType = PropertyAccessorType.none;

  void updateNameByNamingConventionsType() {
    switch (ConfigHelper().config.propertyNamingConventionsType) {
      case PropertyNamingConventionsType.none:
        this.name = key;
        break;
      case PropertyNamingConventionsType.camelCase:
        this.name = camelName(key);
        break;
      case PropertyNamingConventionsType.pascal:
        this.name = upcaseCamelName(key);
        break;
      case PropertyNamingConventionsType.hungarianNotation:
        this.name = underScoreName(key);
        break;
      default:
        this.name = key;
        break;
    }
  }

  void updatePropertyAccessorType() {
    propertyAccessorType = ConfigHelper().config.propertyAccessorType;
  }
}
