import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/models/dart_object.dart';
import 'package:json_to_dart/models/dart_property.dart';

import '../camel_under_score_converter.dart';

class PropertyNameCheckerTextEditingController
    extends ErrorCheckerTextEditingController {
  PropertyNameCheckerTextEditingController(DartProperty property)
      : super(property);

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    // avoid property as following:
    // int int;
    // Test Test;
    // double double;
    // List List;
    // List<int> int;
    if (property is DartObject &&
        (property as DartObject).className.value == text) {
      return errorTextSpan(style);
    } else if (property.value is List) {
      if (text == 'List') {
        return errorTextSpan(style);
      } else if (property.getTypeString().contains('<$text>')) {
        return errorTextSpan(style);
      }
    } else if (property.getBaseTypeString() == text) {
      return errorTextSpan(style);
    }

    return super.buildTextSpan(
        context: context, style: style, withComposing: withComposing);
  }
}

class ClassNameCheckerTextEditingController
    extends ErrorCheckerTextEditingController {
  ClassNameCheckerTextEditingController(DartProperty property)
      : super(property);
}

class ErrorCheckerTextEditingController extends TextEditingController {
  ErrorCheckerTextEditingController(this.property);
  final DartProperty property;
  final DiffMatchPatch dmp = DiffMatchPatch()
    ..diffTimeout = 1
    ..diffEditCost = 4;
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    if (this is ClassNameCheckerTextEditingController &&
        classNameKeyWord.contains(text)) {
      return errorTextSpan(style);
    } else if (propertyKeyWord.contains(text)) {
      return errorTextSpan(style);
    }

    String pass = '';
    for (int i = 0; i < text.length; i++) {
      final String char = text[i];
      if (char == '_' ||
          (pass.isEmpty ? RegExp('[a-zA-Z]') : RegExp('[a-zA-Z0-9]'))
              .hasMatch(char)) {
        pass += char;
      }
    }
    if (pass != text) {
      final List<Diff> diffs = dmp.diff(text, pass);
      dmp.diffCleanupSemantic(diffs);
      final List<TextSpan> textSpans = List<TextSpan>.empty(growable: true);

      for (final Diff diff in diffs) {
        textSpans.add(TextSpan(
          text: diff.text,
          style:
              diff.operation == -1 ? const TextStyle(color: Colors.red) : null,
        ));
      }
      return TextSpan(children: textSpans, style: style);
    }

    return super.buildTextSpan(
        context: context, style: style, withComposing: withComposing);
  }

  TextSpan errorTextSpan(TextStyle? style) {
    return TextSpan(text: text, style: style?.copyWith(color: Colors.red));
  }
}
