import 'dart:convert';

import 'package:dart_style/dart_style.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:json_to_dart/models/dart_property.dart';
import 'package:json_to_dart/utils/dart_helper.dart';
import 'package:json_to_dart/utils/extension.dart';
import 'package:json_to_dart/utils/my_string_buffer.dart';

import 'models/config.dart';
import 'models/dart_object.dart';

void showAlertDialog(String msg, [IconData data = Icons.warning]) {
  SmartDialog.show(
      widget: AlertDialog(
    title: Icon(data),
    content: Text(msg),
    actions: <Widget>[
      TextButton(
        child: Text(appLocalizations.ok),
        onPressed: () {
          SmartDialog.dismiss();
        },
      ),
    ],
  ));
}

class MainController extends GetxController {
  final TextEditingController _textEditingController = TextEditingController();

  final TextEditingController fileHeaderHelpController = TextEditingController()
    ..text = ConfigSetting().fileHeaderInfo;

  DartObject? dartObject;

  String get text => _textEditingController.text;

  set text(String value) {
    _textEditingController.text = value;
  }

  TextEditingController get textEditingController => _textEditingController;

  Set<DartProperty> allProperties = <DartProperty>{};
  Set<DartObject> allObjects = <DartObject>{};
  Set<DartObject> printedObjects = <DartObject>{};

  Future<void> formatJsonAndCreateDartObject() async {
    allProperties.clear();
    allObjects.clear();
    if (text.isNullOrEmpty) {
      return;
    }

    SmartDialog.showLoading(
        widget: const Center(
      child: SpinKitCubeGrid(color: Colors.orange),
    ));

    String inputText = text;
    try {
      if (kIsWeb) {
        // fix https://github.com/dart-lang/sdk/issues/34105
        inputText = text.replaceAll('.0', '.1');
      }

      final dynamic jsonData =
          await compute<String, dynamic>(jsonDecode, inputText)
              .onError((Object? error, StackTrace stackTrace) {
        handleError(error, stackTrace);
      });

      final DartObject? extendedObject = createDartObject(jsonData);
      // final DartObject? extendedObject =
      //     await compute<dynamic, DartObject?>(createDartObject, jsonData)
      //         .onError((Object? error, StackTrace stackTrace) {
      //   handleError(error, stackTrace);
      // });
      if (extendedObject == null) {
        SmartDialog.dismiss();
        showAlertDialog(appLocalizations.illegalJson, Icons.error);
        return;
      }

      dartObject = extendedObject;

      final String? formatJsonString =
          await compute<dynamic, String?>(formatJson, jsonData)
              .onError((Object? error, StackTrace stackTrace) {
        handleError(error, stackTrace);
      });
      if (formatJsonString != null) {
        _textEditingController.text = formatJsonString;
      }

      update();
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
    }
    SmartDialog.dismiss();
  }

  void generateDart() {
    // allProperties.clear();
    // allObjects.clear();
    printedObjects.clear();

    if (dartObject != null) {
      final DartObject? errorObject = allObjects.firstOrNullWhere(
          (DartObject element) =>
              element.classError.isNotEmpty ||
              element.propertyError.isNotEmpty);
      if (errorObject != null) {
        showAlertDialog(errorObject.classError.join('\n') +
            '\n' +
            errorObject.propertyError.join('\n'));
        return;
      }

      final DartProperty? errorProperty = allProperties.firstOrNullWhere(
          (DartProperty element) => element.propertyError.isNotEmpty);

      if (errorProperty != null) {
        showAlertDialog(errorProperty.propertyError.join('\n'));
        return;
      }

      final MyStringBuffer sb = MyStringBuffer();
      try {
        if (ConfigSetting().fileHeaderInfo.isNotEmpty) {
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
            showAlertDialog(appLocalizations.timeFormatError, Icons.error);
          }

          sb.writeLine(info);
        }

        sb.writeLine(DartHelper.jsonImport);

        if (ConfigSetting().addMethod.value) {
          if (ConfigSetting().enableArrayProtection.value) {
            sb.writeLine('import \'dart:developer\';');
            sb.writeLine(ConfigSetting().nullsafety
                ? DartHelper.tryCatchMethodNullSafety
                : DartHelper.tryCatchMethod);
          }

          sb.writeLine(ConfigSetting().enableDataProtection.value
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
        SmartDialog.showToast(appLocalizations.generateSucceed);
      } catch (e, stack) {
        print('$e');
        print('$stack');
        _textEditingController.text = sb.toString();
        showAlertDialog(appLocalizations.generateFailed, Icons.error);
        Clipboard.setData(ClipboardData(text: '$e\n$stack'));
      }
    }
  }

  void orderPropeties() {
    if (dartObject != null) {
      dartObject!.orderPropeties();
      update();
    }
  }

  void selectAll() {
    _textEditingController
      ..text = text
      ..selection = TextSelection(baseOffset: 0, extentOffset: text.length - 1);
  }

  void updateNameByNamingConventionsType() {
    if (dartObject != null) {
      dartObject!.updateNameByNamingConventionsType();
      update();
    }
  }

  void updateNullable(bool nullable) {
    if (dartObject != null) {
      dartObject!.updateNullable(nullable);
    }
  }

  void updatePropertyAccessorType() {
    if (dartObject != null) {
      dartObject!.updatePropertyAccessorType();
    }
  }
}

DartObject? createDartObject(dynamic jsonData) {
  DartObject? extendedObject;

  if (jsonData is Map) {
    extendedObject = DartObject(
      depth: 0,
      keyValuePair:
          MapEntry<String, dynamic>('Root', jsonData as Map<String, dynamic>),
      nullable: false,
      uid: 'Root',
    );
  } else if (jsonData is List) {
    final Map<String, List<dynamic>> root = <String, List<dynamic>>{
      'Root': jsonData
    };
    extendedObject = DartObject(
      depth: 0,
      keyValuePair: MapEntry<String, dynamic>('Root', root),
      nullable: false,
      uid: 'Root',
    ).objectKeys['Root']!
      ..decDepth();
  }
  return extendedObject;
}

String? formatJson(dynamic jsonData) {
  Map<String, dynamic>? jsonObject;
  if (jsonData is Map) {
    jsonObject = jsonData as Map<String, dynamic>;
  } else if (jsonData is List) {
    jsonObject = jsonData.first as Map<String, dynamic>;
  }
  if (jsonObject != null) {
    return const JsonEncoder.withIndent('  ').convert(jsonObject);
  }
  return null;
}

void handleError(Object? e, StackTrace stack) {
  print('$e');
  print('$stack');
  showAlertDialog(appLocalizations.formatErrorInfo, Icons.error);

  Clipboard.setData(ClipboardData(text: '$e\n$stack'));
}
