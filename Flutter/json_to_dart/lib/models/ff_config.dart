import 'package:json_to_dart/main_controller.dart';
import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/models/dart_object.dart';
import 'package:json_to_dart/models/dart_property.dart';
import 'package:json_to_dart_library/json_to_dart_library.dart';

class FFJsonToDartConfig extends JsonToDartConfig {
  @override
  bool get addMethod => ConfigSetting().addMethod.value;

  @override
  bool get enableArrayProtection => ConfigSetting().enableArrayProtection.value;

  @override
  bool get enableDataProtection => ConfigSetting().enableArrayProtection.value;

  @override
  String get fileHeaderInfo => ConfigSetting().fileHeaderInfo;

  @override
  int get traverseArrayCount => ConfigSetting().traverseArrayCount.value;

  @override
  PropertyNamingConventionsType get propertyNamingConventionsType =>
      ConfigSetting().propertyNamingConventionsType.value;

  @override
  PropertyAccessorType get propertyAccessorType =>
      ConfigSetting().propertyAccessorType.value;

  @override
  PropertyNameSortingType get propertyNameSortingType =>
      ConfigSetting().propertyNameSortingType.value;

  @override
  bool get nullsafety => ConfigSetting().nullsafety.value;

  @override
  bool get nullable => ConfigSetting().nullable.value;

  @override
  bool get smartNullable => ConfigSetting().smartNullable.value;

  @override
  bool get addCopyMethod => ConfigSetting().addCopyMethod.value;

  @override
  bool get automaticCheck => ConfigSetting().automaticCheck.value;

  @override
  bool get showResultDialog => ConfigSetting().showResultDialog.value;

  @override
  EqualityMethodType get equalityMethodType =>
      ConfigSetting().equalityMethodType.value;

  @override
  bool get deepCopy => ConfigSetting().deepCopy.value;

  @override
  DartProperty createProperty({
    required String uid,
    required int depth,
    required MapEntry<String, dynamic> keyValuePair,
    required bool nullable,
    required DartObject dartObject,
  }) {
    return FFDartProperty(
      uid: uid,
      keyValuePair: keyValuePair,
      nullable: nullable,
      depth: depth,
      dartObject: dartObject,
    );
  }

  @override
  DartObject createDartObject({
    required String uid,
    required int depth,
    required MapEntry<String, dynamic> keyValuePair,
    required bool nullable,
    DartObject? dartObject,
  }) {
    return FFDartObject(
      uid: uid,
      keyValuePair: keyValuePair,
      nullable: nullable,
      depth: depth,
      dartObject: dartObject,
    );
  }

  @override
  String propertyNameAssert(String uid) {
    return appLocalizations.propertyNameAssert(uid);
  }

  @override
  String classNameAssert(String uid) {
    return appLocalizations.classNameAssert(uid);
  }

  @override
  String get propertyCantSameAsClassName =>
      appLocalizations.propertyCantSameAsClassName;

  @override
  String keywordCheckFailed(Object name) {
    return appLocalizations.keywordCheckFailed(name);
  }

  @override
  String get propertyCantSameAsType => appLocalizations.propertyCantSameAsType;

  @override
  String get containsIllegalCharacters =>
      appLocalizations.containsIllegalCharacters;

  @override
  String get duplicateProperties => appLocalizations.duplicateProperties;

  @override
  String get duplicateClasses => appLocalizations.duplicateClasses;
}
