import 'package:flutter/material.dart';
import 'package:json_to_dart/models/extended_object.dart';
import 'package:json_to_dart/models/extended_property.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:provider/provider.dart';

import '../models/json_to_dart_controller.dart';
import 'json_tree_item.dart';

class JsonTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorPlate.borderGray,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: SingleChildScrollView(child: Consumer<JsonToDartController>(
          builder: (BuildContext context, JsonToDartController controller, _) {
        if (controller.dartObject == null || controller.dartObject?.uid == '') {
          return Container();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildTree(controller.dartObject!),
        );
      })),
    );
  }

  List<Widget> _buildTree(ExtendedObject extendedObject) {
    final List<Widget> list = <Widget>[];
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

    for (final ExtendedProperty item in object.properties) {
      final bool isArray = item.value is List;
      final bool isObject =
          item is ExtendedObject && item.properties.isNotEmpty;

      _drawPoperty(result, object, item,
          isArray: isArray, isObject: isObject, depth: depth);

      if (isObject) {
        _drawOject(result, object.objectKeys[item.key]!, depth: depth);
      } else if (isArray) {
        //var array = item.value as List;
        if (object.objectKeys.containsKey(item.key)) {
          final ExtendedObject oject = object.objectKeys[item.key]!;
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
