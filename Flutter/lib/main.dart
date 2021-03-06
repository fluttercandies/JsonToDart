// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:json_to_dart/models/json_to_dart_controller.dart';
import 'package:json_to_dart/pages/json_text_field.dart';
import 'package:json_to_dart/pages/json_tree.dart';
import 'package:json_to_dart/pages/json_tree_header.dart';
import 'package:json_to_dart/pages/setting.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/utils/config_helper.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'models/extended_object.dart';
import 'package:flutter/foundation.dart';

void main() {
  //set for desktop
  if (!kIsWeb) {
    // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  ConfigHelper().initialize();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JsonToDartController controller = JsonToDartController();
    return OKToast(
      radius: 4,
      backgroundColor: ColorPlate.black.withOpacity(0.6),
      child: MultiProvider(
        providers: [
          Provider.value(
            value: controller,
          ),
          ValueListenableProvider<TextEditingController>.value(
            value: controller.textEditingControllerValue,
          ),
          ValueListenableProvider<ExtendedObject>.value(
            value: controller.extendedObjectValue,
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          //debugShowMaterialGrid: false,

          title: 'Json To Dart',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // See https://github.com/flutter/flutter/wiki/Desktop-shells#fonts
            fontFamily: 'Roboto',
          ),
          home: MyHomePage(title: 'Json To Dart'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPlate.white,
      body: Row(
        children: <Widget>[
          Expanded(
            flex: ConfigHelper().config.column1Width,
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: JsonTextField(),
                  ),
                  Setting(),
                ],
              ),
            ),
          ),
          Listener(
            onPointerDown: onPointerDown,
            onPointerUp: onPointerUp,
            onPointerMove: onPointerMove,
            behavior: HitTestBehavior.translucent,
            child: DragIcon(),
          ),
          Expanded(
            flex: ConfigHelper().config.column2Width,
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  JsonTreeHeader(),
                  Expanded(
                    child: JsonTree(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool pointerPressed = false;
  void updateGridSplitter(double x) {
    var width = (MediaQuery.of(context).size.width) /
        (ConfigHelper().config.column1Width +
            ConfigHelper().config.column2Width);
    var width1 = max(width * ConfigHelper().config.column1Width + x, 50.0);
    var width2 = max(width * ConfigHelper().config.column2Width - x, 50.0);

    ConfigHelper().config.column1Width =
        (double.parse((width1 / (width1 + width2)).toStringAsFixed(5)) * 10000)
            .toInt();
    ConfigHelper().config.column2Width =
        (double.parse((width2 / (width1 + width2)).toStringAsFixed(5)) * 10000)
            .toInt();
    // print(
    //     "${ConfigHelper().config.column1Width}---------${ConfigHelper().config.column2Width}");
  }

  void onPointerDown(PointerDownEvent event) {
    pointerPressed = true;
  }

  void onPointerUp(PointerUpEvent event) {
    pointerPressed = false;
  }

  void onPointerMove(PointerMoveEvent event) {
    if (pointerPressed) {
      setState(() {
        updateGridSplitter(event.delta.dx);
      });
    }
  }
}

// 提示你这里可以滑
class DragIcon extends StatelessWidget {
  const DragIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.0,
      alignment: Alignment.center,
      height: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 14,
            width: 2,
            decoration: ShapeDecoration(
              color: ColorPlate.gray.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          Container(width: 4),
          Container(
            height: 14,
            width: 2,
            decoration: ShapeDecoration(
              color: ColorPlate.gray.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
