import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_to_dart/models/json_to_dart_controller.dart';
import 'package:json_to_dart/utils/config_helper.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:oktoast/oktoast.dart';
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Wrap(
          direction: Axis.horizontal,
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
                Clipboard.setData(ClipboardData(text: controller.text));
              },
            ),
            FlatButton(
              child: Text("粘贴"),
              onPressed: () {
                Clipboard.getData("text/plain").then((value) {
                  controller.text = value.text;
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
                child: Text("保存配置"),
                onPressed: () {
                  ConfigHelper().save();
                  showToast("保存配置成功");
                }),
            FlatButton(
                child: Text("生成Dart"),
                onPressed: () {
                  controller.generateDart();
                }),
          
          ],
        ),
        if (showMoreSetting)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Checkbox(
                          value: ConfigHelper().config.enableDataProtection,
                          onChanged: (value) {
                            setState(() {
                              ConfigHelper().config.enableDataProtection =
                                  value;
                            });
                          },
                        ),
                        Text("数据类型全方位保护"),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Checkbox(
                            value: ConfigHelper().config.enableArrayProtection,
                            onChanged: (value) {
                              setState(() {
                                ConfigHelper().config.enableArrayProtection =
                                    value;
                              });
                            },
                          ),
                          Text("数组全方位保护"),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                                ConfigHelper().config.traverseArrayCount =
                                    value;
                                controller.formatJson();
                              });
                            },
                          ),
                          Text("遍历数组次数"),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          DropdownButton(
                            value: ConfigHelper()
                                .config
                                .propertyNamingConventionsType,
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
                                value: PropertyNamingConventionsType
                                    .hungarianNotation,
                                child: Text("匈牙利命名下划线"),
                              )
                            ],
                            onChanged: (value) {
                              setState(() {
                                ConfigHelper()
                                    .config
                                    .propertyNamingConventionsType = value;
                                controller.updateNameByNamingConventionsType();
                              });
                            },
                          ),
                          Text("属性命名"),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          DropdownButton(
                            value:
                                ConfigHelper().config.propertyNameSortingType,
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
                                controller.orderPropeties();
                              });
                            },
                          ),
                          Text("属性排序"),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
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
                      )),
                ],
              ),
             Align(child:  Text(
                "文件头部信息",
                textAlign: TextAlign.left,
              ),alignment: Alignment.centerLeft,),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0)),
                child: TextField(
                  maxLines: null,
                  controller: TextEditingController()
                    ..text = ConfigHelper().config.fileHeaderInfo,
                  onChanged: (value) {
                    ConfigHelper().config.fileHeaderInfo = value;
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText:
                          "可以在这里添加copyright，导入dart代码，创建人信息等等。支持[Date yyyy MM-dd]来生成时间，Date后面为日期格式"),
                ),
                height: 200.0,
              ),
            ],
          )
      ],
    );
  }
}
