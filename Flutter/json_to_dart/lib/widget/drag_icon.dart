import 'package:flutter/material.dart';
import 'package:json_to_dart/style/color.dart';

class DragIcon extends StatelessWidget {
  const DragIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.0,
      alignment: Alignment.center,
      height: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 14,
            width: 2,
            decoration: ShapeDecoration(
              color: ColorPlate.gray.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          Container(width: 4),
          Container(
            height: 14,
            width: 2,
            decoration: ShapeDecoration(
              color: ColorPlate.gray.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
