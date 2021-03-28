import 'package:flutter/material.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/size.dart';
import 'package:json_to_dart/style/text.dart';
import 'tapped.dart';

class TapButton extends StatelessWidget {
  const TapButton({
    Key? key,
    this.icon,
    this.title,
    this.onPressed,
  }) : super(key: key);
  final IconData? icon;
  final String? title;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: ColorPlate.blue,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon ?? Icons.help_outline,
              color: ColorPlate.white,
              size: SysSize.normal + 2,
            ),
            Container(width: 4),
            Container(
              // color: ColorPlate.red,
              child: StText.normal(
                title ?? '--',
                style: const TextStyle(color: ColorPlate.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
