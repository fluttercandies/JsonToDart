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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
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
          GestureDetector(
            child: Container(
              width: 16.0,
              color: Color(0x01000000),
              alignment: Alignment.center,
              height: double.infinity,
              child: Text("||"),
            ),
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
}
