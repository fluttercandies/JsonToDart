import 'package:equatable/equatable.dart';

import 'package:get/get.dart';
import 'package:json_to_dart/main_controller.dart';
import 'package:json_to_dart/models/dart_object.dart';
import 'package:json_to_dart/models/dart_property.dart';
import 'package:json_to_dart/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/utils/extension.dart';

enum DartErrorType {
  classNameEmpty,
  propertyNameEmpty,
  keyword,
}

class DartError extends Equatable {
  const DartError(this.content);
  final String content;
  @override
  List<Object?> get props => <Object>[content];
}

abstract class DartErrorChecker {
  DartErrorChecker(this.property);
  final DartProperty property;
  void checkError(RxString input);
}

class EmptyErrorChecker extends DartErrorChecker {
  EmptyErrorChecker(DartProperty property) : super(property);

  @override
  void checkError(RxString input) {
    late String errorInfo;
    late RxSet<String> out;
    // property change
    if (identical(input, property.name)) {
      errorInfo = appLocalizations.propertyNameAssert(property.uid);
      out = property.propertyError;
    }
    // class name change
    else {
      final DartObject object = property as DartObject;
      errorInfo = appLocalizations.classNameAssert(object.uid);
      out = object.classError;
    }

    if (input.isEmpty) {
      out.add(errorInfo);
    } else {
      out.remove(errorInfo);
    }
  }
}

class ValidityChecker extends DartErrorChecker {
  ValidityChecker(DartProperty property) : super(property);

  @override
  void checkError(RxString input) {
    String? errorInfo;
    late RxSet<String> out;
    final String value = input.value;
    // property change
    if (identical(input, property.name)) {
      if (propertyKeyWord.contains(value)) {
        errorInfo = appLocalizations.keywordCheckFailed(value);
      } else if (property is DartObject &&
          (property as DartObject).className.value == value) {
        errorInfo = appLocalizations.propertyCantSameAsClassName;
      } else if (property.value is List) {
        if (value == 'List') {
          errorInfo = appLocalizations.propertyCantSameAsType;
        } else if (property.getTypeString().contains('<$value>')) {
          errorInfo = appLocalizations.propertyCantSameAsType;
        }
      } else if (property.getBaseTypeString() == value) {
        errorInfo = appLocalizations.propertyCantSameAsType;
      }
      out = property.propertyError;
    }
    // class name change
    else {
      final DartObject object = property as DartObject;
      if (classNameKeyWord.contains(value)) {
        errorInfo = appLocalizations.keywordCheckFailed(value);
      }
      out = object.classError;
    }

    if (errorInfo == null) {
      String temp = '';
      for (int i = 0; i < value.length; i++) {
        final String char = value[i];
        if (char == '_' ||
            (temp.isEmpty ? RegExp('[a-zA-Z]') : RegExp('[a-zA-Z0-9]'))
                .hasMatch(char)) {
          temp += char;
        } else {
          errorInfo = appLocalizations.containsIllegalCharacters;
          break;
        }
      }
    }

    out.removeWhere((String element) => element.startsWith('vcf: '));
    if (errorInfo != null) {
      out.add('vcf: ' + errorInfo);
    }
  }
}

class DuplicateClassChecker extends DartErrorChecker {
  DuplicateClassChecker(DartObject property) : super(property);

  DartObject get dartObject => property as DartObject;

  Map<String, DartObject> duplicateClass = <String, DartObject>{};

  @override
  void checkError(RxString input) {
    if (!identical(input, dartObject.className)) {
      return;
    }
    final MainController controller = Get.find<MainController>();
    final String errorInfo = appLocalizations.duplicateClasses;
    for (final DartObject oj in controller.allObjects) {
      if (oj == dartObject) {
        continue;
      }

      if (!duplicateClass.containsKey(oj.uid) &&
          oj.className.value == dartObject.className.value) {
        duplicateClass[oj.uid] = oj;
      } else if (oj.className.value != dartObject.className.value &&
          duplicateClass.remove(oj.uid) != null) {
        oj.duplicateClassChecker.duplicateClass.remove(dartObject.uid);
        if (oj.duplicateClassChecker.duplicateClass.isEmpty) {
          oj.classError.remove(errorInfo);
        }
      }
    }

    if (duplicateClass.isEmpty) {
      dartObject.classError.remove(errorInfo);
    } else {
      for (final MapEntry<String, DartObject> entry in duplicateClass.entries) {
        entry.value.duplicateClassChecker.duplicateClass[dartObject.uid] =
            dartObject;
        for (final MapEntry<String, DartObject> entry1
            in duplicateClass.entries) {
          if (entry1.key != entry.key) {
            entry.value.duplicateClassChecker.duplicateClass[entry1.key] =
                entry1.value;
          }
        }
        entry.value.classError.add(errorInfo);
      }
      dartObject.classError.add(errorInfo);
    }
  }
}
