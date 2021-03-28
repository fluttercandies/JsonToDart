import 'package:flutter/material.dart';
import 'package:json_to_dart/localizations/app_localizations.dart';
import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/text.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:provider/provider.dart';

import '../models/config.dart';
import '../widget/checkBox.dart';

class JsonTreeHeader extends StatefulWidget {
  @override
  _JsonTreeHeaderState createState() => _JsonTreeHeaderState();
}

class _JsonTreeHeaderState extends State<JsonTreeHeader> {
  @override
  Widget build(BuildContext context) {
    // final JsonToDartController controller =
    //     Provider.of<JsonToDartController>(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
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
            child: DropdownButton<PropertyAccessorType>(
              value: ConfigSetting().propertyAccessorType,
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
                setState(() {
                  //controller.updatePropertyAccessorType();
                  ConfigSetting().propertyAccessorType = value!;
                  ConfigSetting().save();
                });
              },
            ),
          ),
          flex: 1,
        ),
        Selector<ConfigSetting, bool>(
            builder: (BuildContext c, bool value, Widget? child) {
              if (value) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: StCheckBox(
                      title: AppLocalizations.of(context).nullable,
                      value: ConfigSetting().nullable,
                      onChanged: (bool value) {
                        setState(() {
                          //controller.updateNullable(value);
                          ConfigSetting().nullable = value;
                          ConfigSetting().save();
                        });
                      },
                    ),
                  ),
                  flex: 1,
                );
              } else {
                return Container();
              }
            },
            selector: (BuildContext c, ConfigSetting vm) => vm.nullsafety)
      ],
    );
  }
}
