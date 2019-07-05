import 'dart:math';

import 'package:flutter_web/material.dart';
import 'package:json_to_dart/src/models/extended_object.dart';
import 'package:json_to_dart/src/models/json_to_dart_controller.dart';
import 'package:json_to_dart/src/pages/json_text_field.dart';
import 'package:json_to_dart/src/pages/json_tree.dart';
import 'package:json_to_dart/src/pages/json_tree_header.dart';
import 'package:json_to_dart/src/pages/setting.dart';
import 'package:json_to_dart/src/utils/config_helper.dart';
import 'package:json_to_dart/src/utils/oktoast/oktoast.dart';

import 'src/utils/provider/provider.dart';

void main() {
  ConfigHelper().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    JsonToDartController controller = JsonToDartController();
    return DropdownButtonHideUnderline(
      child: OKToast(
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
            ),
            home: MyHomePage(title: 'Json To Dart'),
          ),
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
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
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
