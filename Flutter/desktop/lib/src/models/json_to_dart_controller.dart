import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_to_dart/src/models/extended_object.dart';
import 'package:json_to_dart/src/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/src/utils/config_helper.dart';
import 'package:json_to_dart/src/utils/dart_helper.dart';
import 'package:json_to_dart/src/utils/my_string_buffer.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';

class JsonToDartController with ChangeNotifier {
  ExtendedObject _extendedObject;

  String get value => _textEditingController.text;

  void changeValue(String value, {bool notify: false}) {
    _textEditingController.text = value;
    if (notify) {
      notifyListeners();
    }
  }

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController get textEditingController => _textEditingController;

  void formatJson() {
    try {
      var jsonObject = json.decode(_textEditingController.text);
      _extendedObject = ExtendedObject(
          depth: 0,
          keyValuePair: MapEntry<String, Map>("Root", jsonObject),
          uid: "Root");
      changeValue(JsonEncoder.withIndent("  ").convert(jsonObject),
          notify: true);
    } catch (e) {
      showToast("json格式错误");
    }
  }

  void generateDart() {
    if (_extendedObject != null) {
      try {
        MyStringBuffer sb = new MyStringBuffer();
        if (!IsNullOrWhiteSpace(ConfigHelper().config.fileHeaderInfo)) {
          var info = ConfigHelper().config.fileHeaderInfo;
          //[Date MM-dd HH:mm]
          try {
            var start = info.indexOf("[Date");
            var startIndex = start;
            if (start >= 0) {
              start = start + "[Date".length;
              var end = info.indexOf("]", start);
              if (end >= start) {
                var format = info.substring(start, end - start).trim();

                var replaceString =
                    info.substring(startIndex, end - startIndex + 1);
                if (format == null || format == "") {
                  format = "yyyy MM-dd";
                }

                info = info.replaceAll(
                    replaceString, DateFormat(format).format(DateTime.now()));
              }
            }
          } catch (Exception) {}

          sb.writeLine(info);
        }

        sb.writeLine(DartHelper.jsonImport);
        if (ConfigHelper().config.addMethod &&
            (ConfigHelper().config.enableDataProtection ||
                ConfigHelper().config.enableArrayProtection)) {
          ///debugPrint
          sb.writeLine(DartHelper.debugPrintImport);
        }

        if (ConfigHelper().config.addMethod) {
          if (ConfigHelper().config.enableDataProtection) {
            sb.writeLine(DartHelper.convertMethod);
          }

          if (ConfigHelper().config.enableArrayProtection) {
            sb.writeLine(DartHelper.tryCatchMethod);
          }
        }

        sb.writeLine(_extendedObject.toString());
        changeValue(sb.toString(), notify: true);
        Clipboard.setData(ClipboardData(text: _textEditingController.text));
        showToast("Dart生成成功\n已复制到剪切板");
      } catch (e, stack) {
        print("$e");
        print("$stack");
      }
    }
  }

  void selectAll() {
    _textEditingController = TextEditingController.fromValue(TextEditingValue(
        text: value,
        selection:
            TextSelection(baseOffset: 0, extentOffset: value.length - 1)));
    notifyListeners();
  }
}
