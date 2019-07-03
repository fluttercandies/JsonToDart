import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_to_dart/src/models/json_to_dart_controller.dart';
import 'package:json_to_dart/src/utils/config_helper.dart';
import 'package:json_to_dart/src/utils/enums.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool showMoreSetting = false;

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<JsonToDartController>(context);
    return Column(
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              FlatButton(
                child: Text("格式化"),
                onPressed: () {
                  controller.formatJson();
                },
              ),
              FlatButton(
                  child: Text("更多设置"),
                  onPressed: () {
                    setState(() {
                      showMoreSetting = !showMoreSetting;
                    });
                  }),
              FlatButton(
                child: Text("复制"),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: controller.value));
                },
              ),
              FlatButton(
                child: Text("粘贴"),
                onPressed: () {
                  Clipboard.getData("text/plain").then((value) {
                    controller.changeValue(value.text, notify: true);
                  });
                },
              ),
              FlatButton(
                child: Text("全选"),
                onPressed: () {
                  controller.selectAll();
                },
              ),
              FlatButton(
                  child: Text("生成Dart"),
                  onPressed: () {
                    controller.generateDart();
                  }),
            ],
          ),
        ),
        if (showMoreSetting)
          LayoutBuilder(
            builder: (_, data) {
              int count = 1;
              if (data.maxWidth > 600.0) {
                count = 3;
              } else if (data.maxWidth > 400.0) {
                count = 2;
              }

              Widget result = Wrap(
               
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: ConfigHelper().config.enableDataProtection,
                        onChanged: (value) {
                          setState(() {
                            ConfigHelper().config.enableDataProtection = value;
                          });
                        },
                      ),
                      Text("数据类型全方位保护"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: ConfigHelper().config.enableArrayProtection,
                        onChanged: (value) {
                          setState(() {
                            ConfigHelper().config.enableArrayProtection = value;
                          });
                        },
                      ),
                      Text("数组全方位保护"),
                    ],
                  ),
                  Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DropdownButton(
                        value: ConfigHelper().config.traverseArrayCount,
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: Text("1"),
                          ),
                          DropdownMenuItem(
                            value: 20,
                            child: Text("20"),
                          ),
                          DropdownMenuItem(
                            value: 99,
                            child: Text("99"),
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            ConfigHelper().config.traverseArrayCount = value;
                          });
                        },
                      ),
                      Text("遍历数组次数"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DropdownButton(
                        value:
                            ConfigHelper().config.propertyNamingConventionsType,
                        items: [
                          DropdownMenuItem(
                            value: PropertyNamingConventionsType.none,
                            child: Text("保持原样"),
                          ),
                          DropdownMenuItem(
                            value: PropertyNamingConventionsType.camelCase,
                            child: Text("驼峰式命名小驼峰"),
                          ),
                          DropdownMenuItem(
                            value: PropertyNamingConventionsType.pascal,
                            child: Text("帕斯卡命名大驼峰"),
                          ),
                          DropdownMenuItem(
                            value:
                                PropertyNamingConventionsType.hungarianNotation,
                            child: Text("匈牙利命名下划线"),
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            ConfigHelper()
                                .config
                                .propertyNamingConventionsType = value;
                          });
                        },
                      ),
                      Text("属性命名"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DropdownButton(
                        value: ConfigHelper().config.propertyNameSortingType,
                        items: [
                          DropdownMenuItem(
                            value: PropertyNameSortingType.none,
                            child: Text("保持原样"),
                          ),
                          DropdownMenuItem(
                            value: PropertyNameSortingType.ascending,
                            child: Text("升序排列"),
                          ),
                          DropdownMenuItem(
                            value: PropertyNameSortingType.descending,
                            child: Text("降序排序"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            ConfigHelper().config.propertyNameSortingType =
                                value;
                          });
                        },
                      ),
                      Text("属性排序"),
                    ],
                  ),
                  Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: ConfigHelper().config.addMethod,
                        onChanged: (value) {
                          setState(() {
                            ConfigHelper().config.addMethod = value;
                          });
                        },
                      ),
                      Text("添加保护方法"),
                    ],
                  ),
                ],
              );

              return Container(
                //height: data.maxWidth / count * (6 / count),
                width: data.maxWidth,
                child: result,
              );
            },
          )
      ],
    );
  }
}
