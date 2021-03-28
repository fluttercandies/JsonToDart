import 'package:flutter/material.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/text.dart';

class StPicker extends StatelessWidget {
  const StPicker({
    Key? key,
    this.child,
    this.title,
  }) : super(key: key);
  final DropdownButton<dynamic>? child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        color: ColorPlate.lightGray,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StText.small(title ?? '--'),
          Container(width: 14),
          child ?? Container(),
        ],
      ),
    );
  }
}
