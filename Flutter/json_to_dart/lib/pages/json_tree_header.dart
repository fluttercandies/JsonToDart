import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/main_controller.dart';

import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/text.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:json_to_dart/utils/extension.dart';

import '../models/config.dart';
import '../widget/checkBox.dart';

class JsonTreeHeader extends StatelessWidget {
  const JsonTreeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: StText.normal(
              'JsonKey',
              style: TextStyle(
                color: ColorPlate.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          flex: 3,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: StText.normal(
              appLocalizations.type,
              style: const TextStyle(
                color: ColorPlate.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: StText.normal(
              appLocalizations.name,
              style: const TextStyle(
                color: ColorPlate.gray,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Obx(() {
              return DropdownButton<PropertyAccessorType>(
                value: ConfigSetting().propertyAccessorType.value,
                underline: Container(),
                items: PropertyAccessorType.values
                    .where((PropertyAccessorType element) =>
                        element == PropertyAccessorType.none ||
                        element == PropertyAccessorType.final_)
                    .map<DropdownMenuItem<PropertyAccessorType>>(
                        (PropertyAccessorType f) =>
                            DropdownMenuItem<PropertyAccessorType>(
                              value: f,
                              child: Text(f
                                  .toString()
                                  .replaceAll('PropertyAccessorType.', '')
                                  .replaceAll('_', '')
                                  .toLowerCase()),
                            ))
                    .toList(),
                onChanged: (PropertyAccessorType? value) {
                  //controller.updatePropertyAccessorType();
                  ConfigSetting().propertyAccessorType.value = value!;
                  ConfigSetting().save();
                },
              );
            }),
          ),
          flex: 1,
        ),
        Obx(() {
          if (ConfigSetting().nullsafety.value) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: StCheckBox(
                  title: appLocalizations.nullable,
                  value: ConfigSetting().nullable.value,
                  onChanged: (bool value) {
                    ConfigSetting().nullable.value = value;
                    ConfigSetting().save();
                    Get.find<MainController>().updateNullable(value);
                  },
                ),
              ),
              flex: 1,
            );
          } else {
            return Container(
              width: 0,
              height: 0,
            );
          }
        }),
      ],
    );
  }
}
