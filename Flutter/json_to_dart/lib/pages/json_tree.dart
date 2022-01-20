import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/main_controller.dart';
import 'package:json_to_dart/models/dart_object.dart';
import 'package:json_to_dart/models/dart_property.dart';
import 'package:json_to_dart/style/color.dart';
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
      child: SingleChildScrollView(child: GetBuilder<MainController>(
        builder: (MainController controller) {
          if (controller.dartObject == null ||
              controller.dartObject?.uid == '') {
            return Container();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildTree(controller.dartObject!),
          );
        },
      )),
    );
  }

  List<Widget> _buildTree(DartObject extendedObject) {
    final List<Widget> list = <Widget>[];
    _drawOject(
      list,
      extendedObject,
    );
    return list;
  }

  void _drawOject(List<Widget> result, DartObject object, {int depth = 0}) {
    ///root
    if (object.depth == 0) {
      _drawPoperty(result, object, object,
          isArray: false, isObject: true, depth: -1);
    }

    for (final DartProperty item in object.properties) {
      final bool isArray = item.value is List;
      final bool isObject = item is DartObject && item.properties.isNotEmpty;

      _drawPoperty(result, object, item,
          isArray: isArray, isObject: isObject, depth: depth);

      if (isObject) {
        _drawOject(result, object.objectKeys[item.key]!, depth: depth);
      } else if (isArray) {
        //var array = item.value as List;
        if (object.objectKeys.containsKey(item.key)) {
          final DartObject oject = object.objectKeys[item.key]!;
          _drawPoperty(result, object, oject,
              depth: depth + 1, isArrayOject: true, isObject: true);
          _drawOject(result, oject, depth: depth + 2);
        }
      }
    }
  }

  void _drawPoperty(
      List<Widget> result, DartObject object, DartProperty property,
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
