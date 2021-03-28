import 'dart:convert';

import 'package:dart_style/dart_style.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_to_dart/localizations/app_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/utils/dart_helper.dart';
import 'package:json_to_dart/utils/my_string_buffer.dart';

import 'extended_object.dart';

class JsonToDartController extends ChangeNotifier {
  final TextEditingController _textEditingController = TextEditingController();
  TextEditingController get textEditingController => _textEditingController;

  ExtendedObject? dartObject;

  String get text => _textEditingController.text;
  set text(String value) {
    _textEditingController.text;
  }

  void formatJson() {
    if (isNullOrWhiteSpace(text)) {
      return;
    }
    try {
      final Map<String, dynamic> jsonObject =
          jsonDecode(text) as Map<String, dynamic>;
      final ExtendedObject extendedObject = ExtendedObject(
          depth: 0,
          keyValuePair: MapEntry<String, dynamic>('Root', jsonObject),
          uid: 'Root');
      dartObject = extendedObject;
      _textEditingController.text =
          const JsonEncoder.withIndent('  ').convert(jsonObject);
      notifyListeners();
    } catch (e, stack) {
      print('$e');
      print('$stack');
      showToast(AppLocalizations.instance.formatErrorInfo,
          duration: const Duration(seconds: 5));
      Clipboard.setData(ClipboardData(text: '$e\n$stack'));
    }
  }

  void generateDart() {
    if (dartObject != null) {
      final String? msg = dartObject?.hasEmptyProperties();
      if (!isNullOrWhiteSpace(msg)) {
        showToast(msg!);
        return;
      }

      try {
        final MyStringBuffer sb = MyStringBuffer();
        if (!isNullOrWhiteSpace(ConfigSetting().fileHeaderInfo)) {
          String info = ConfigSetting().fileHeaderInfo;
          //[Date MM-dd HH:mm]
          try {
            int start = info.indexOf('[Date');
            final int startIndex = start;
            if (start >= 0) {
              start = start + '[Date'.length;
              final int end = info.indexOf(']', start);
              if (end >= start) {
                String format = info.substring(start, end - start).trim();

                final String replaceString =
                    info.substring(startIndex, end - startIndex + 1);
                if (format == '') {
                  format = 'yyyy MM-dd';
                }

                info = info.replaceAll(
                    replaceString, DateFormat(format).format(DateTime.now()));
              }
            }
          } catch (e) {
            showToast(AppLocalizations.instance.timeFormatError);
          }

          sb.writeLine(info);
        }

        sb.writeLine(DartHelper.jsonImport);

        if (ConfigSetting().addMethod) {
          if (ConfigSetting().enableArrayProtection) {
            sb.writeLine(DartHelper.debugPrintImport);
            sb.writeLine(DartHelper.tryCatchMethod);
          }

          sb.writeLine(ConfigSetting().enableDataProtection
              ? DartHelper.asTMethodWithDataProtection
              : DartHelper.asTMethod);
        }

        sb.writeLine(dartObject?.toString());
        String result = sb.toString();

        final DartFormatter formatter = DartFormatter();

        result = formatter.format(result);

        _textEditingController.text = result;
        Clipboard.setData(ClipboardData(text: result));
        showToast(AppLocalizations.instance.generateSucceed);
      } catch (e, stack) {
        print('$e');
        print('$stack');
        showToast(AppLocalizations.instance.generateFailed,
            duration: const Duration(seconds: 5));
        Clipboard.setData(ClipboardData(text: '$e\n$stack'));
      }
    }
  }

  void selectAll() {
    _textEditingController
      ..text = text
      ..selection = TextSelection(baseOffset: 0, extentOffset: text.length - 1);
  }

  void orderPropeties() {
    if (dartObject != null) {
      dartObject!.orderPropeties();
      notifyListeners();
    }
  }

  void updateNameByNamingConventionsType() {
    if (dartObject != null) {
      dartObject!.updateNameByNamingConventionsType();
      notifyListeners();
    }
  }

  void updatePropertyAccessorType() {
    if (dartObject != null) {
      dartObject!.updatePropertyAccessorType();
    }
  }

  void updateNullable(bool nullable) {
    if (dartObject != null) {
      dartObject!.updateNullable(nullable);
    }
  }
}

class ExtendedObjectValue extends ValueNotifier<ExtendedObject?> {
  ExtendedObjectValue(ExtendedObject? value) : super(value);
}

class TextEditingControllerValue extends ValueNotifier<TextEditingController> {
  TextEditingControllerValue(TextEditingController value) : super(value);
}
