import 'package:flutter/material.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/size.dart';
import 'package:json_to_dart/style/text.dart';
import 'package:tapped/tapped.dart';

class TapButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onPressed;

  const TapButton({
    Key key,
    this.icon,
    this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tapped(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          color: ColorPlate.blue,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                style: TextStyle(color: ColorPlate.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
