import 'dart:collection';

import 'package:get/get.dart';
import 'package:json_to_dart/utils/error_check/text_editing_controller.dart';
import 'package:json_to_dart_library/json_to_dart_library.dart';

import 'dart_property.dart';

// ignore: must_be_immutable
class FFDartObject extends DartObject
    with FFDartObjectMixin, FFDartPropertyMixin {
  FFDartObject({
    required super.uid,
    required super.keyValuePair,
    required super.depth,
    required super.nullable,
    super.dartObject,
  }) {
    classNameTextEditingController.text = className;
  }
}

mixin FFDartObjectMixin on DartObject {
  late ClassNameCheckerTextEditingController classNameTextEditingController =
      ClassNameCheckerTextEditingController(this);

  RxString classNameObs = ''.obs;
  @override
  String get className => classNameObs.value;

  @override
  set className(String value) {
    classNameObs.value = value;
  }

  final RxSet<String> _classError = <String>{}.obs;
  @override
  SetBase<String> get classError => _classError;
}
