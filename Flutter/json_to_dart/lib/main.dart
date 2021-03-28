import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nested/nested.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'localizations/app_localizations.dart';
import 'models/config.dart';
import 'models/json_to_dart_controller.dart';
import 'navigator/navigator.dart';
import 'pages/json_text_field.dart';
import 'pages/json_tree.dart';
import 'pages/json_tree_header.dart';
import 'pages/setting.dart';
import 'style/color.dart';
import 'widget/drag_icon.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await ConfigSetting().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final JsonToDartController controller = JsonToDartController();
  @override
  Widget build(BuildContext context) {
    return OKToast(
      radius: 4,
      backgroundColor: ColorPlate.black.withOpacity(0.6),
      child: MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<JsonToDartController>.value(
              value: controller,
            ),
            ChangeNotifierProvider<ConfigSetting>.value(
              value: ConfigSetting(),
            )
          ],
          child: Selector<ConfigSetting, Locale>(
            selector: (BuildContext c, ConfigSetting vm) => vm.locale,
            builder: (BuildContext c, Locale value, Widget? child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Json To Dart',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                navigatorKey: AppNavigator().key,
                home: const MyHomePage(title: 'Json To Dart'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: ConfigSetting().locale,
              );
            },
          )),
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
                  SettingWidget(),
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
    final double width = (MediaQuery.of(context).size.width) /
        (ConfigSetting().column1Width + ConfigSetting().column2Width);
    final double width1 = max(width * ConfigSetting().column1Width + x, 50.0);
    final double width2 = max(width * ConfigSetting().column2Width - x, 50.0);

    ConfigSetting().column1Width =
        (double.parse((width1 / (width1 + width2)).toStringAsFixed(5)) * 10000)
            .toInt();
    ConfigSetting().column2Width =
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
