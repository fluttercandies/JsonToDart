import 'package:flutter/material.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/size.dart';
import 'package:json_to_dart/style/text.dart';
import 'tapped.dart';

class StCheckBox extends StatelessWidget {
  const StCheckBox({
    Key? key,
    this.title,
    this.value = false,
    this.onChanged,
  }) : super(key: key);
  final String? title;
  final bool? value;
  final Function(bool)? onChanged;

  Color get color => value! ? ColorPlate.blue : ColorPlate.gray;

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: () => onChanged?.call(!value!),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: ColorPlate.lightGray,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              value! ? Icons.check_box : Icons.check_box_outline_blank,
              color: color,
              size: SysSize.normal + 2,
            ),
            Container(width: 4),
            StText.normal(
              title ?? '--',
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
