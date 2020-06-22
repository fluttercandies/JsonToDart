import 'package:flutter/material.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:provider/provider.dart';

// TODO: 修复UI,完成
class JsonTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TextEditingController>(
      builder: (context, controller, _) {
        return Container(
          margin: EdgeInsets.only(top: 10.0),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            color: ColorPlate.lightGray,
          ),
          child: TextField(
            controller: controller,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "输入你的Json，然后点击格式化按钮",
              hintStyle: TextStyle(
                color: ColorPlate.gray,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        );
      },
    );
  }
}
