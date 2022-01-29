import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'main_controller.dart';
import 'models/config.dart';
import 'pages/json_text_field.dart';
import 'pages/json_tree.dart';
import 'pages/json_tree_header.dart';
import 'pages/setting.dart';
import 'style/color.dart';
import 'widget/drag_icon.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await ConfigSetting().init();
  Get.put(MainController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Json To Dart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: FlutterSmartDialog.init(),
      home: const MyHomePage(title: 'Json To Dart'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: ConfigSetting().locale.value,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

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
            flex: ConfigSetting().column1Width,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: JsonTextField(),
                  ),
                  const SettingWidget(),
                ],
              ),
            ),
          ),
          Listener(
            onPointerDown: onPointerDown,
            onPointerUp: onPointerUp,
            onPointerMove: onPointerMove,
            behavior: HitTestBehavior.translucent,
            child: const DragIcon(),
          ),
          Expanded(
            flex: ConfigSetting().column2Width,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  const JsonTreeHeader(),
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
  double delta = 0;
  void updateGridSplitter(double x) {
    delta += x;
    if (delta.abs() > 10) {
      final double width = (MediaQuery.of(context).size.width) /
          (ConfigSetting().column1Width + ConfigSetting().column2Width);
      final double width1 =
          max(width * ConfigSetting().column1Width + delta, 50.0);
      final double width2 =
          max(width * ConfigSetting().column2Width - delta, 50.0);
      ConfigSetting().column1Width =
          (double.parse((width1 / (width1 + width2)).toStringAsFixed(5)) *
                  10000)
              .toInt();
      ConfigSetting().column2Width =
          (double.parse((width2 / (width1 + width2)).toStringAsFixed(5)) *
                  10000)
              .toInt();
      delta = 0;
    }
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
