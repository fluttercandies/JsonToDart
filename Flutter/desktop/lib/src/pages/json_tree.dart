import 'package:flutter/material.dart';
import 'package:json_to_dart_library/json_to_dart_library.dart';
import 'package:json_to_dart/src/pages/json_tree_item.dart';
import 'package:provider/provider.dart';

class JsonTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 1.0)),
      child: SingleChildScrollView(
          child: Consumer<ExtendedObject>(builder: (context, object, _) {
        if (object == null || object.uid=="") return Container();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildTree(object),
        );
      })),
    );
  }

  List<Widget> _buildTree(ExtendedObject extendedObject) {
    List<Widget> list = [];
    _drawOject(
      list,
      extendedObject,
    );
    return list;
  }

  void _drawOject(List<Widget> result, ExtendedObject object, {int depth = 0}) {
    ///root
    if (object.depth == 0) {
      _drawPoperty(result, object, object,
          isArray: false, isObject: true, depth: -1);
    }

    for (var item in object.properties) {
      bool isArray = item.value is List;
      bool isObject = (item is ExtendedObject && item.properties.length > 0);

      _drawPoperty(result, object, item,
          isArray: isArray, isObject: isObject, depth: depth);

      if (isObject) {
        _drawOject(result, object.objectKeys[item.key], depth: depth);
      } else if (isArray) {
        //var array = item.value as List;
        if (object.objectKeys.containsKey(item.key)) {
          var oject = object.objectKeys[item.key];
          _drawPoperty(result, object, oject,
              depth: depth + 1, isArrayOject: true, isObject: true);
          _drawOject(result, oject, depth: depth + 2);
        }
      }
    }
  }

  void _drawPoperty(
      List<Widget> result, ExtendedObject object, ExtendedProperty property,
      {bool isArray = false,
      bool isObject = false,
      int depth = 0,
      bool isArrayOject = false}) {
    result.add(JsonTreeItem(
      object,
      property,
      isArray: isArray,
      isObject: isObject,
      isArrayOject: isArrayOject,
      depth: depth,
    ));
  }
}
