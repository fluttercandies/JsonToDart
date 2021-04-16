import 'dart:convert';

import 'package:dart_style/dart_style.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_to_dart/localizations/app_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/utils/dart_helper.dart';
import 'package:json_to_dart/utils/my_string_buffer.dart';

import 'dart_object.dart';

class JsonToDartController extends ChangeNotifier {
  final TextEditingController _textEditingController = TextEditingController();

  TextEditingController get textEditingController => _textEditingController;

  DartObject? dartObject;

  String get text => _textEditingController.text;

  set text(String value) {
    _textEditingController.text;
  }

  void formatJson() {
    if (isNullOrWhiteSpace(text)) {
      return;
    }
    String inputText = text;
    try {
      if (kIsWeb) {
        // fix https://github.com/dart-lang/sdk/issues/34105
        inputText = text.replaceAll('.0', '.1');
      }

      final dynamic jsonData = jsonDecode(inputText);
      late final Map<String, dynamic> jsonObject;
      if (jsonData is Map) {
        jsonObject = jsonDecode(inputText) as Map<String, dynamic>;
      } else if (jsonData is List) {
        jsonObject = jsonData
            .map((dynamic e) => e as Map<String, dynamic>)
            .fold(<String, dynamic>{},
                (Object? previousValue, Map<String, dynamic> eachJson) {
          final Map<String, dynamic> previous =
              previousValue as Map<String, dynamic>;
          for (final MapEntry<String, dynamic> element in eachJson.entries) {
            if (!previous.containsKey(element.key)) {
              previous.addEntries(<MapEntry<String, dynamic>>[element]);
            }
          }
          return previous;
        });
      }
      final DartObject extendedObject = DartObject(
        depth: 0,
        keyValuePair: MapEntry<String, dynamic>('Root', jsonObject),
        uid: 'Root',
      );
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
    printedObjects.clear();
    if (dartObject != null) {
      final String? msg = dartObject?.hasEmptyProperties();
      if (!isNullOrWhiteSpace(msg)) {
        showToast(msg!);
        return;
      }
      final MyStringBuffer sb = MyStringBuffer();
      try {
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
            sb.writeLine('import \'dart:developer\';');
            sb.writeLine(ConfigSetting().nullsafety
                ? DartHelper.tryCatchMethodNullSafety
                : DartHelper.tryCatchMethod);
          }

          sb.writeLine(ConfigSetting().enableDataProtection
              ? ConfigSetting().nullsafety
                  ? DartHelper.asTMethodWithDataProtectionNullSafety
                  : DartHelper.asTMethodWithDataProtection
              : ConfigSetting().nullsafety
                  ? DartHelper.asTMethodNullSafety
                  : DartHelper.asTMethod);
        }

        sb.writeLine(dartObject!.toString());
        String result = sb.toString();

        final DartFormatter formatter = DartFormatter();

        result = formatter.format(result);

        _textEditingController.text = result;
        Clipboard.setData(ClipboardData(text: result));
        showToast(AppLocalizations.instance.generateSucceed);
      } catch (e, stack) {
        print('$e');
        print('$stack');
        _textEditingController.text = sb.toString();
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
      notifyListeners();
    }
  }
}

class ExtendedObjectValue extends ValueNotifier<DartObject?> {
  ExtendedObjectValue(DartObject? value) : super(value);
}

class TextEditingControllerValue extends ValueNotifier<TextEditingController> {
  TextEditingControllerValue(TextEditingController value) : super(value);
}
