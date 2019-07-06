import 'package:flutter_web/material.dart';
import 'package:json_to_dart/src/models/json_to_dart_controller.dart';
import 'package:json_to_dart_library/json_to_dart_library.dart';
import 'package:json_to_dart/src/utils/config_helper.dart';
import 'package:json_to_dart/src/utils/provider/src/provider.dart';


class JsonTreeHeader extends StatefulWidget {
  @override
  _JsonTreeHeaderState createState() => _JsonTreeHeaderState();
}

class _JsonTreeHeaderState extends State<JsonTreeHeader> {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<JsonToDartController>(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child:Text("JsonKey")),
          flex: 3,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child:Text("类型")),
          flex: 1,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("参数名字"),
          ),
          flex: 1,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child:DropdownButton(
            value: ConfigHelper().config.propertyAccessorType,
            
            items: [
              DropdownMenuItem(
                value: PropertyAccessorType.none,
                child: Text("none"),
              ),
              DropdownMenuItem(
                value: PropertyAccessorType.Final,
                child: Text("final"),
              ),
              DropdownMenuItem(
                value: PropertyAccessorType.get,
                child: Text("get"),
              ),
              DropdownMenuItem(
                value: PropertyAccessorType.getSet,
                child: Text("getSet"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                ConfigHelper().config.propertyAccessorType = value;
                controller.updatePropertyAccessorType();
              });
            },
          )),
          flex: 1,
        ),
      ],
    );
  }
}
