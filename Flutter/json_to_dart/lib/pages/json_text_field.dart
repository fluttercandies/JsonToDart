import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/main_controller.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/utils/extension.dart';

class JsonTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find();
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        color: ColorPlate.lightGray,
      ),
      child: TextField(
        controller: controller.textEditingController,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: appLocalizations.inputHelp,
          hintStyle: const TextStyle(
            color: ColorPlate.gray,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
