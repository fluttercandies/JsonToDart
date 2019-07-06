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

import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:json_to_dart/src/models/json_to_dart_controller.dart';
import 'package:json_to_dart/src/pages/json_text_field.dart';
import 'package:json_to_dart/src/pages/json_tree.dart';
import 'package:json_to_dart/src/pages/json_tree_header.dart';
import 'package:json_to_dart/src/pages/setting.dart';
import 'package:json_to_dart_library/json_to_dart_library.dart';
import 'package:json_to_dart/src/utils/config_helper.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  ConfigHelper().initialize();

  // SystemChannels.lifecycle.setMessageHandler((msg) {
  //   print('SystemChannels> $msg');
  // });
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JsonToDartController controller = JsonToDartController();
    return OKToast(
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

class _MyHomePageState extends State<MyHomePage>

//with WidgetsBindingObserver
{
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print(state);
  //   if (state == AppLifecycleState.suspending) {
  //     ConfigHelper().save();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            key: key1,
            flex: ConfigHelper().config.column1Width,
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Setting(),
                  Expanded(
                    child: JsonTextField(),
                  )
                ],
              ),
            ),
          ),
          Listener(
            onPointerDown: onPointerDown,
            onPointerUp: onPointerUp,
            onPointerMove: onPointerMove,
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: 16.0,
              color: Color(0x01000000),
              alignment: Alignment.center,
              height: double.infinity,
              child: Text("||"),
            ),
          ),
          Expanded(
            key: key2,
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
    var width1 = max(key1.currentContext.size.width + x, 50.0);
    var width2 = max(key2.currentContext.size.width - x, 50.0);
    ConfigHelper().config.column1Width =
        (double.parse((width1 / (width1 + width2)).toStringAsFixed(5)) * 10000)
            .toInt();
    ConfigHelper().config.column2Width =
        (double.parse((width2 / (width1 + width2)).toStringAsFixed(5)) * 10000)
            .toInt();
    print(
        "${ConfigHelper().config.column1Width}---------${ConfigHelper().config.column2Width}");
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
