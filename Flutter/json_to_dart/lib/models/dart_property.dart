// ignore_for_file: must_be_immutable

import 'dart:collection';

import 'package:get/get.dart';

import 'package:json_to_dart/utils/error_check/text_editing_controller.dart';
import 'package:json_to_dart_library/json_to_dart_library.dart';

class FFDartProperty extends DartProperty with FFDartPropertyMixin {
  FFDartProperty({
    required super.uid,
    required super.depth,
    required super.keyValuePair,
    required super.nullable,
    required super.dartObject,
  }) {
    nullableObs.value = nullable;
    propertyAccessorTypeObs.value = propertyAccessorType;
    typeObs.value = type;
    nameObs.value = name;

    nameTextEditingController.text = nameObs.value;
  }
}

mixin FFDartPropertyMixin on DartProperty {
  late PropertyNameCheckerTextEditingController nameTextEditingController =
      nameTextEditingController =
          PropertyNameCheckerTextEditingController(this);

  RxString nameObs = ''.obs;
  @override
  String get name => nameObs.value;
  @override
  set name(String value) {
    nameObs.value = value;
  }

  Rx<PropertyAccessorType> propertyAccessorTypeObs =
      PropertyAccessorType.none.obs;

  @override
  PropertyAccessorType get propertyAccessorType =>
      propertyAccessorTypeObs.value;
  @override
  set propertyAccessorType(PropertyAccessorType value) {
    propertyAccessorTypeObs.value = value;
  }

  RxBool nullableObs = false.obs;

  @override
  bool get nullable => nullableObs.value;
  @override
  set nullable(bool value) {
    nullableObs.value = value;
  }

  Rx<DartType> typeObs = DartType.Object.obs;
  @override
  DartType get type => typeObs.value;

  @override
  set type(DartType value) {
    typeObs.value = value;
  }

  final RxSet<String> _propertyError = <String>{}.obs;
  @override
  SetBase<String> get propertyError => _propertyError;

  @override
  void updateNameByNamingConventionsType() {
    super.updateNameByNamingConventionsType();
    nameTextEditingController.text = name;
  }
}
