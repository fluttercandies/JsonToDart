import 'package:dartx/dartx.dart';
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
      }
      // PropertyAndClassNameSameChecker has do this
      // else if (property is DartObject &&
      //     (property as DartObject).className.value == value) {
      //   errorInfo = appLocalizations.propertyCantSameAsClassName;
      // }
      else if (property.value is List) {
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

  @override
  void checkError(RxString input) {
    if (!identical(input, dartObject.className)) {
      return;
    }

    final MainController controller = Get.find<MainController>();

    final Map<String, List<DartObject>> groupObjects = controller.allObjects
        .groupBy((DartObject element) => element.className.value);
    final String errorInfo = appLocalizations.duplicateClasses;
    for (final MapEntry<String, List<DartObject>> item
        in groupObjects.entries) {
      for (final DartObject element in item.value) {
        if (item.value.length > 1) {
          element.classError.add(errorInfo);
        } else {
          element.classError.remove(errorInfo);
        }
      }
    }
  }
}

class DuplicatePropertyNameChecker extends DartErrorChecker {
  DuplicatePropertyNameChecker(DartProperty property) : super(property);
  @override
  void checkError(RxString input) {
    if (property.dartObject == null || !identical(input, property.name)) {
      return;
    }

    final DartObject dartObject = property.dartObject!;
    final String errorInfo = appLocalizations.duplicateProperties;
    final Map<String, List<DartProperty>> groupProperies = dartObject.properties
        .groupBy((DartProperty element) => element.name.value);

    for (final MapEntry<String, List<DartProperty>> item
        in groupProperies.entries) {
      for (final DartProperty element in item.value) {
        if (item.value.length > 1) {
          element.propertyError.add(errorInfo);
        } else {
          element.propertyError.remove(errorInfo);
        }
      }
    }
  }
}

class PropertyAndClassNameSameChecker extends DartErrorChecker {
  PropertyAndClassNameSameChecker(DartProperty property) : super(property);
  @override
  void checkError(RxString input) {
    final String errorInfo = appLocalizations.propertyCantSameAsClassName;
    final MainController controller = Get.find<MainController>();
    final Set<DartProperty> hasErrorProperites = <DartProperty>{};
    for (final DartObject dartObject in controller.allObjects) {
      final Iterable<DartProperty> list =
          controller.allProperties.where((DartProperty element) {
        final bool same = element.name.value == dartObject.className.value;
        if (same) {
          hasErrorProperites.add(element);
          element.propertyError.add(errorInfo);
        }
        return same;
      });

      if (list.isNotEmpty) {
        dartObject.classError.add(errorInfo);
      } else {
        dartObject.classError.remove(errorInfo);
      }
    }

    for (final DartProperty item in controller.allProperties) {
      if (!hasErrorProperites.contains(item)) {
        item.propertyError.remove(errorInfo);
      }
    }
  }
}
