import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_to_dart_library/json_to_dart_library.dart';
import 'package:json_to_dart/src/utils/config_helper.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';

class JsonToDartController {
  TextEditingControllerValue _textEditingControllerValue =
      TextEditingControllerValue(TextEditingController());

  TextEditingControllerValue get textEditingControllerValue =>
      _textEditingControllerValue;

  ExtendedObjectValue _extendedObjectValue = ExtendedObjectValue(null);

  ExtendedObjectValue get extendedObjectValue => _extendedObjectValue;

  String get text => textEditingControllerValue.value.text;
  set text(String value) {
    textEditingControllerValue.value = TextEditingController(text: value);
  }

  void formatJson() {
    if (isNullOrWhiteSpace(text)) {
      return;
    }
    try {
      var jsonObject = json.decode(text);
      var extendedObject = ExtendedObject(
          depth: 0,
          keyValuePair: MapEntry<String, Map>("Root", jsonObject),
          uid: "Root");
      extendedObjectValue.value = extendedObject;
      textEditingControllerValue.value = TextEditingController()
        ..text = JsonEncoder.withIndent("  ").convert(jsonObject);
    } catch (e, stack) {
      print("$e");
      print("$stack");
       showToast("格式错误,错误信息已复制到剪切板",duration: Duration(seconds: 5));
         Clipboard.setData(ClipboardData(text: "$e\n$stack"));
    }
  }

  void generateDart() {
    if (extendedObjectValue.value != null) {
      var msg = extendedObjectValue.value.hasEmptyProperties();
      if (!isNullOrWhiteSpace(msg)) {
        showToast(msg);
        return;
      }

      try {
        MyStringBuffer sb = new MyStringBuffer();
        if (!isNullOrWhiteSpace(ConfigHelper().config.fileHeaderInfo)) {
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
          } catch (Exception) {
            showToast("时间格式错误");
          }

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

        sb.writeLine(extendedObjectValue.value.toString());
        var result = sb.toString();

        textEditingControllerValue.value = TextEditingController()
          ..text = result;
        Clipboard.setData(ClipboardData(text: result));
        showToast("Dart生成成功\n已复制到剪切板");
      } catch (e, stack) {
        print("$e");
        print("$stack");
         showToast("生成Dart错误,错误信息已复制到剪切板",duration: Duration(seconds: 5));
         Clipboard.setData(ClipboardData(text: "$e\n$stack"));
      }
    }
  }

  void selectAll() {
    textEditingControllerValue.value = TextEditingController()
      ..text = text
      ..selection = TextSelection(baseOffset: 0, extentOffset: text.length - 1);
  }

  void orderPropeties() {
    if (extendedObjectValue.value != null) {
      var temp = extendedObjectValue.value;
      temp.orderPropeties();
      extendedObjectValue.value = temp.copy();
    }
  }

  void updateNameByNamingConventionsType() {
    if (extendedObjectValue.value != null) {
      var temp = extendedObjectValue.value;
      temp.updateNameByNamingConventionsType();
      extendedObjectValue.value = temp.copy();
    }
  }

  void updatePropertyAccessorType() {
    if (extendedObjectValue.value != null) {
      var temp = extendedObjectValue.value;
      temp.updatePropertyAccessorType();
      extendedObjectValue.value = temp.copy();
    }
  }
}

class ExtendedObjectValue extends ValueNotifier<ExtendedObject> {
  ExtendedObjectValue(ExtendedObject value) : super(value);
}

class TextEditingControllerValue extends ValueNotifier<TextEditingController> {
  TextEditingControllerValue(TextEditingController value) : super(value);
}
