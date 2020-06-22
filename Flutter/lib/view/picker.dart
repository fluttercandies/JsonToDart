import 'package:flutter/material.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/text.dart';

// class PickerItem<T>{
//   final String title;
//   final T value
// }
class StPicker extends StatelessWidget {
  final DropdownButton child;
  final String title;

  const StPicker({
    Key key,
    this.child,
    this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        color: ColorPlate.lightGray,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StText.small(title ?? "--"),
          Container(width: 14),
          child ?? Container(),
        ],
      ),
    );
  }
}
