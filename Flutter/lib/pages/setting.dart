import 'package:flutter/material.dart';
import 'package:json_to_dart/models/json_to_dart_controller.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/text.dart';
import 'package:json_to_dart/utils/config_helper.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:json_to_dart/view/button.dart';
import 'package:json_to_dart/view/checkBox.dart';
import 'package:json_to_dart/view/picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<JsonToDartController>(context, listen: false);
    var settingRow = Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        TapButton(
          title: "格式化",
          icon: Icons.format_align_left,
          onPressed: () {
            controller.formatJson();
          },
        ),
        TapButton(
          title: "更多设置",
          icon: Icons.more_horiz,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return Container(
                  height: double.infinity,
                  child: MoreSetting(
                    controller: controller,
                  ),
                );
              },
            );
          },
        ),
        TapButton(
          title: "保存配置",
          icon: Icons.save,
          onPressed: () {
            ConfigHelper().save();
            showToast("保存配置成功");
          },
        ),
        TapButton(
          title: "生成Dart",
          icon: Icons.flag,
          onPressed: () {
            controller.generateDart();
          },
        ),
      ],
    );
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: settingRow,
    );
  }
}

class MoreSetting extends StatefulWidget {
  final JsonToDartController controller;

  const MoreSetting({Key key, this.controller}) : super(key: key);
  @override
  _MoreSettingState createState() => _MoreSettingState();
}

class _MoreSettingState extends State<MoreSetting> {
  JsonToDartController get controller => widget.controller;
  @override
  Widget build(BuildContext context) {
    var buttonGroup = Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        StCheckBox(
          title: "数据类型全方位保护",
          value: ConfigHelper().config.enableDataProtection,
          onChanged: (value) {
            setState(() {
              ConfigHelper().config.enableDataProtection = value;
            });
          },
        ),
        StCheckBox(
          title: "数据全方位保护",
          value: ConfigHelper().config.enableArrayProtection,
          onChanged: (value) {
            setState(() {
              ConfigHelper().config.enableArrayProtection = value;
            });
          },
        ),
        StPicker(
          title: "遍历数组次数",
          child: DropdownButton(
            value: ConfigHelper().config.traverseArrayCount,
            iconEnabledColor: ColorPlate.blue,
            elevation: 1,
            style: StandardTextStyle.normal.apply(color: ColorPlate.blue),
            items: [
              DropdownMenuItem(
                value: 1,
                child: StText.normal("1"),
              ),
              DropdownMenuItem(
                value: 20,
                child: StText.normal("20"),
              ),
              DropdownMenuItem(
                value: 99,
                child: StText.normal("99"),
              )
            ],
            onChanged: (value) {
              setState(() {
                ConfigHelper().config.traverseArrayCount = value;
                if (controller.extendedObjectValue.value != null) {
                  controller.formatJson();
                }
              });
            },
          ),
        ),
        StPicker(
          title: "属性命名",
          child: DropdownButton(
            iconEnabledColor: ColorPlate.blue,
            value: ConfigHelper().config.propertyNamingConventionsType,
            items: [
              DropdownMenuItem(
                value: PropertyNamingConventionsType.none,
                child: StText.normal("保持原样"),
              ),
              DropdownMenuItem(
                value: PropertyNamingConventionsType.camelCase,
                child: StText.normal("驼峰式命名小驼峰"),
              ),
              DropdownMenuItem(
                value: PropertyNamingConventionsType.pascal,
                child: StText.normal("帕斯卡命名大驼峰"),
              ),
              DropdownMenuItem(
                value: PropertyNamingConventionsType.hungarianNotation,
                child: StText.normal("匈牙利命名下划线"),
              )
            ],
            onChanged: (value) {
              setState(() {
                ConfigHelper().config.propertyNamingConventionsType = value;
                controller.updateNameByNamingConventionsType();
              });
            },
          ),
        ),
        StPicker(
          title: "属性排序",
          child: DropdownButton(
            iconEnabledColor: ColorPlate.blue,
            value: ConfigHelper().config.propertyNameSortingType,
            items: [
              DropdownMenuItem(
                value: PropertyNameSortingType.none,
                child: StText.normal("保持原样"),
              ),
              DropdownMenuItem(
                value: PropertyNameSortingType.ascending,
                child: StText.normal("升序排列"),
              ),
              DropdownMenuItem(
                value: PropertyNameSortingType.descending,
                child: StText.normal("降序排序"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                ConfigHelper().config.propertyNameSortingType = value;
                controller.orderPropeties();
              });
            },
          ),
        ),
        StCheckBox(
          title: "添加保护方法",
          value: ConfigHelper().config.addMethod,
          onChanged: (value) {
            setState(() {
              ConfigHelper().config.addMethod = value;
            });
          },
        ),
      ],
    );
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buttonGroup,
          Align(
            child: StText.small(
              "文件头部信息",
            ),
            alignment: Alignment.centerLeft,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              color: ColorPlate.lightGray,
            ),
            child: TextField(
              maxLines: null,
              controller: TextEditingController()
                ..text = ConfigHelper().config.fileHeaderInfo,
              onChanged: (value) {
                ConfigHelper().config.fileHeaderInfo = value;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
                hintText:
                    "可以在这里添加copyright，导入dart代码，创建人信息等等。支持[Date yyyy MM-dd]来生成时间，Date后面为日期格式",
              ),
            ),
            height: 200.0,
          ),
        ],
      ),
    );
  }
}
