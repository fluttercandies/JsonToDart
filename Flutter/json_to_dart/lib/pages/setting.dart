import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/models/json_to_dart_controller.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/text.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:json_to_dart/widget/button.dart';
import 'package:json_to_dart/widget/checkBox.dart';
import 'package:json_to_dart/widget/picker.dart';
import 'package:json_to_dart/i18n.dart';
import 'package:provider/provider.dart';

class SettingWidget extends StatefulWidget {
  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  @override
  Widget build(BuildContext context) {
    final JsonToDartController controller =
        Provider.of<JsonToDartController>(context, listen: false);
    final AppLocalizations appLocalizations = I18n.of(context);
    final Wrap settingRow = Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        TapButton(
          title: appLocalizations.formatButtonLabel,
          icon: Icons.format_align_left,
          onPressed: () {
            controller.formatJson();
          },
        ),
        TapButton(
          title: appLocalizations.generateButtonLabel,
          icon: Icons.flag,
          onPressed: () {
            controller.generateDart();
          },
        ),
        TapButton(
          title: appLocalizations.settingButtonLabel,
          icon: Icons.more_horiz,
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext ctx) {
                return Container(
                  height: double.infinity,
                  child: MoreSetting(controller),
                );
              },
            ).whenComplete(() {
              ConfigSetting().save();
            });
          },
        ),
        StPicker(
          title: 'Language',
          child: DropdownButton<Locale>(
            value: ConfigSetting().locale,
            iconEnabledColor: ColorPlate.blue,
            elevation: 1,
            style: StandardTextStyle.normal.apply(color: ColorPlate.blue),
            items: AppLocalizations.supportedLocales
                .map((Locale locale) => DropdownMenuItem<Locale>(
                      value: locale,
                      child: StText.normal(locale.toString()),
                    ))
                .toList(),
            onChanged: (Locale? value) {
              setState(() {
                ConfigSetting().locale = value!;
              });
            },
          ),
        ),
      ],
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: settingRow,
    );
  }
}

class MoreSetting extends StatefulWidget {
  const MoreSetting(
    this.controller, {
    Key? key,
  }) : super(key: key);
  final JsonToDartController controller;

  @override
  _MoreSettingState createState() => _MoreSettingState();
}

class _MoreSettingState extends State<MoreSetting> {
  JsonToDartController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = I18n.of(context);
    final Wrap buttonGroup = Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        StCheckBox(
          title: appLocalizations.dataProtection,
          value: ConfigSetting().enableDataProtection,
          onChanged: (bool value) {
            setState(() {
              ConfigSetting().enableDataProtection = value;
            });
          },
        ),
        StCheckBox(
          title: appLocalizations.arrayProtection,
          value: ConfigSetting().enableArrayProtection,
          onChanged: (bool value) {
            setState(() {
              ConfigSetting().enableArrayProtection = value;
            });
          },
        ),
        StPicker(
          title: appLocalizations.traverseArrayCount,
          child: DropdownButton<int>(
            value: ConfigSetting().traverseArrayCount,
            iconEnabledColor: ColorPlate.blue,
            elevation: 1,
            style: StandardTextStyle.normal.apply(color: ColorPlate.blue),
            items: const <DropdownMenuItem<int>>[
              DropdownMenuItem<int>(
                value: 1,
                child: StText.normal('1'),
              ),
              DropdownMenuItem<int>(
                value: 20,
                child: StText.normal('20'),
              ),
              DropdownMenuItem<int>(
                value: 99,
                child: StText.normal('99'),
              )
            ],
            onChanged: (int? value) {
              if (ConfigSetting().traverseArrayCount != value) {
                setState(() {
                  ConfigSetting().traverseArrayCount = value!;
                  if (controller.dartObject != null) {
                    controller.formatJson();
                  }
                });
              }
            },
          ),
        ),
        StPicker(
          title: appLocalizations.nameRule,
          child: DropdownButton<PropertyNamingConventionsType>(
            iconEnabledColor: ColorPlate.blue,
            value: ConfigSetting().propertyNamingConventionsType,
            items: <DropdownMenuItem<PropertyNamingConventionsType>>[
              DropdownMenuItem<PropertyNamingConventionsType>(
                value: PropertyNamingConventionsType.none,
                child: StText.normal(appLocalizations.original),
              ),
              DropdownMenuItem<PropertyNamingConventionsType>(
                value: PropertyNamingConventionsType.camelCase,
                child: StText.normal(appLocalizations.camelCase),
              ),
              DropdownMenuItem<PropertyNamingConventionsType>(
                value: PropertyNamingConventionsType.pascal,
                child: StText.normal(appLocalizations.pascal),
              ),
              DropdownMenuItem<PropertyNamingConventionsType>(
                value: PropertyNamingConventionsType.hungarianNotation,
                child: StText.normal(appLocalizations.hungarianNotation),
              )
            ],
            onChanged: (PropertyNamingConventionsType? value) {
              if (ConfigSetting().propertyNamingConventionsType != value) {
                setState(() {
                  ConfigSetting().propertyNamingConventionsType = value!;
                  controller.updateNameByNamingConventionsType();
                });
              }
            },
          ),
        ),
        StPicker(
          title: appLocalizations.propertyOrder,
          child: DropdownButton<PropertyNameSortingType>(
            iconEnabledColor: ColorPlate.blue,
            value: ConfigSetting().propertyNameSortingType,
            items: <DropdownMenuItem<PropertyNameSortingType>>[
              DropdownMenuItem<PropertyNameSortingType>(
                value: PropertyNameSortingType.none,
                child: StText.normal(appLocalizations.original),
              ),
              DropdownMenuItem<PropertyNameSortingType>(
                value: PropertyNameSortingType.ascending,
                child: StText.normal(appLocalizations.ascending),
              ),
              DropdownMenuItem<PropertyNameSortingType>(
                value: PropertyNameSortingType.descending,
                child: StText.normal(appLocalizations.descending),
              ),
            ],
            onChanged: (PropertyNameSortingType? value) {
              if (ConfigSetting().propertyNameSortingType != value) {
                setState(() {
                  ConfigSetting().propertyNameSortingType = value!;
                  controller.orderPropeties();
                });
              }
            },
          ),
        ),
        StCheckBox(
          title: appLocalizations.addMethod,
          value: ConfigSetting().addMethod,
          onChanged: (bool value) {
            setState(() {
              ConfigSetting().addMethod = value;
            });
          },
        ),
        StCheckBox(
          title: appLocalizations.nullsafety,
          value: ConfigSetting().nullsafety,
          onChanged: (bool value) {
            setState(() {
              ConfigSetting().nullsafety = value;
              ConfigSetting().nullable = true;
              if (!value) {
                ConfigSetting().smartNullable = false;
              }
            });
          },
        ),
        if (ConfigSetting().nullsafety)
          StCheckBox(
            title: appLocalizations.smartNullable,
            value: ConfigSetting().smartNullable,
            onChanged: (bool value) {
              setState(() {
                ConfigSetting().smartNullable = value;
              });
            },
          ),
      ],
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buttonGroup,
          Align(
            child: StText.small(
              appLocalizations.fileHeader,
            ),
            alignment: Alignment.centerLeft,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              color: ColorPlate.lightGray,
            ),
            child: TextField(
              maxLines: null,
              controller: TextEditingController()
                ..text = ConfigSetting().fileHeaderInfo,
              onChanged: (String value) {
                ConfigSetting().fileHeaderInfo = value;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: InputBorder.none,
                hintStyle: const TextStyle(color: Colors.grey),
                hintText: appLocalizations.fileHeaderHelp,
              ),
            ),
            height: 200.0,
          ),
        ],
      ),
    );
  }
}
