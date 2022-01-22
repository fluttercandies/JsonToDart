import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
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
  DartErrorChecker({required this.property});
  final DartProperty property;
  void checkError(RxString input);
}

class EmptyErrorChecker extends DartErrorChecker {
  EmptyErrorChecker({required DartProperty property})
      : super(property: property);

  @override
  void checkError(RxString input) {
    late String errorInfo;
    late RxSet<String> out;
    // property change
    if (input == property.name) {
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
  ValidityChecker({required DartProperty property}) : super(property: property);

  @override
  void checkError(RxString input) {
    String? errorInfo;
    late RxSet<String> out;
    final String value = input.value;
    // property change
    if (input == property.name) {
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
