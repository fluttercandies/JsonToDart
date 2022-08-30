import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/main_controller.dart';
import 'package:json_to_dart/models/config.dart';
import 'package:json_to_dart/pages/result.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/text.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:json_to_dart/utils/extension.dart';
import 'package:json_to_dart/widget/button.dart';
import 'package:json_to_dart/widget/checkBox.dart';
import 'package:json_to_dart/widget/picker.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();
    final Wrap settingRow = Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        TapButton(
          title: appLocalizations.formatButtonLabel,
          icon: Icons.format_align_left,
          onPressed: () {
            controller.formatJsonAndCreateDartObject();
          },
        ),
        TapButton(
          title: appLocalizations.generateButtonLabel,
          icon: Icons.flag,
          onPressed: () {
            final String? dartText = controller.generateDart();
            if (dartText == null) {
              return;
            }
            if (ConfigSetting().showResultDialog.value) {
              SmartDialog.compatible.show(
                widget: ResultDialog(
                  text: dartText,
                ),
              );
            }
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
                  child: const MoreSetting(),
                );
              },
            ).whenComplete(() {});
          },
        ),
        Obx(() {
          return StPicker(
            title: 'Language',
            child: DropdownButton<Locale>(
              value: ConfigSetting().locale.value,
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
                ConfigSetting().locale.value = value!;
                Get.updateLocale(ConfigSetting().locale.value);
                controller.formatJsonAndCreateDartObject();
              },
            ),
          );
        }),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: settingRow,
    );
  }
}

class MoreSetting extends StatelessWidget {
  const MoreSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();
    final Wrap buttonGroup = Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        Obx(() {
          return StCheckBox(
            title: appLocalizations.dataProtection,
            value: ConfigSetting().enableDataProtection.value,
            onChanged: (bool value) {
              if (ConfigSetting().enableDataProtection.value != value) {
                ConfigSetting().enableDataProtection.value = value;
              }
            },
          );
        }),
        Obx(() {
          return StCheckBox(
            title: appLocalizations.arrayProtection,
            value: ConfigSetting().enableArrayProtection.value,
            onChanged: (bool value) {
              if (value != ConfigSetting().enableArrayProtection.value) {
                ConfigSetting().enableArrayProtection.value = value;
              }
            },
          );
        }),
        Obx(() {
          return StPicker(
            title: appLocalizations.traverseArrayCount,
            child: DropdownButton<int>(
              value: ConfigSetting().traverseArrayCount.value,
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
                if (ConfigSetting().traverseArrayCount.value != value) {
                  ConfigSetting().traverseArrayCount.value = value!;

                  if (controller.dartObject != null) {
                    controller.formatJsonAndCreateDartObject();
                  }
                }
              },
            ),
          );
        }),
        Obx(() {
          return StPicker(
            title: appLocalizations.nameRule,
            child: DropdownButton<PropertyNamingConventionsType>(
              iconEnabledColor: ColorPlate.blue,
              value: ConfigSetting().propertyNamingConventionsType.value,
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
                if (ConfigSetting().propertyNamingConventionsType.value !=
                    value) {
                  ConfigSetting().propertyNamingConventionsType.value = value!;

                  controller.updateNameByNamingConventionsType();
                }
              },
            ),
          );
        }),
        Obx(() {
          return StPicker(
            title: appLocalizations.propertyOrder,
            child: DropdownButton<PropertyNameSortingType>(
              iconEnabledColor: ColorPlate.blue,
              value: ConfigSetting().propertyNameSortingType.value,
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
                if (ConfigSetting().propertyNameSortingType.value != value) {
                  ConfigSetting().propertyNameSortingType.value = value!;

                  controller.orderPropeties();
                }
              },
            ),
          );
        }),
        Obx(() {
          return StCheckBox(
            title: appLocalizations.addMethod,
            value: ConfigSetting().addMethod.value,
            onChanged: (bool value) {
              if (ConfigSetting().addMethod.value != value) {
                ConfigSetting().addMethod.value = value;
              }
            },
          );
        }),
        Obx(() {
          return StCheckBox(
            title: appLocalizations.nullsafety,
            value: ConfigSetting().nullsafety.value,
            onChanged: (bool value) {
              ConfigSetting().nullsafety.value = value;
              if (!value) {
                ConfigSetting().smartNullable.value = false;
              }
            },
          );
        }),
        Obx(() {
          if (ConfigSetting().nullsafety.value) {
            return StCheckBox(
              title: appLocalizations.smartNullable,
              value: ConfigSetting().smartNullable.value,
              onChanged: (bool value) {
                ConfigSetting().smartNullable.value = value;
                // if (!value) {
                //   controller.updateNullable(true);
                // }
              },
            );
          }
          return Container(
            width: 0,
            height: 0,
          );
        }),
        Obx(() {
          return StCheckBox(
            title: appLocalizations.addCopyMethod,
            value: ConfigSetting().addCopyMethod.value,
            onChanged: (bool value) {
              if (ConfigSetting().addCopyMethod.value != value) {
                ConfigSetting().addCopyMethod.value = value;
              }
            },
          );
        }),
        Obx(() {
          return StCheckBox(
            title: appLocalizations.automaticCheck,
            value: ConfigSetting().automaticCheck.value,
            onChanged: (bool value) {
              ConfigSetting().automaticCheck.value = value;
            },
          );
        }),
        Obx(() {
          return StCheckBox(
            title: appLocalizations.showResultDialog,
            value: ConfigSetting().showResultDialog.value,
            onChanged: (bool value) {
              if (value != ConfigSetting().showResultDialog.value) {
                ConfigSetting().showResultDialog.value = value;
              }
            },
          );
        }),
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
              controller: controller.fileHeaderHelpController,
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
