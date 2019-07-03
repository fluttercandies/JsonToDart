import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_to_dart/src/models/json_to_dart_controller.dart';
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
          Wrap(
            children: <Widget>[
              Container(
                width: 300.0,
                height: 100.0,
                color: Colors.blue,
              )
            ],
          )
      ],
    );
  }
}
