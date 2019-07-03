import 'package:flutter/material.dart';
import 'package:json_to_dart/src/models/json_to_dart_controller.dart';
import 'package:provider/provider.dart';

class JsonTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<JsonToDartController>(
      builder: (context, controller, _) {
        return TextField(
          controller: controller.textEditingController,
          maxLines: null,
        );
      },
    );
  }
}
