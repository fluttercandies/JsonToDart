import 'package:flutter/material.dart';
import 'color.dart';
import 'size.dart';

class StandardTextStyle {
  static const TextStyle big = TextStyle(
    fontFamily: 'MyraidPro',
    fontWeight: FontWeight.w600,
    fontSize: SysSize.big,
    color: ColorPlate.darkGray,
    inherit: true,
  );
  static const TextStyle normalW = TextStyle(
    fontFamily: 'MyraidPro',
    fontWeight: FontWeight.w600,
    fontSize: SysSize.normal,
    color: ColorPlate.darkGray,
    inherit: true,
  );
  static const TextStyle normal = TextStyle(
    fontFamily: 'MyraidPro',
    fontWeight: FontWeight.normal,
    fontSize: SysSize.normal,
    color: ColorPlate.darkGray,
    inherit: true,
  );
  static const TextStyle small = TextStyle(
    fontFamily: 'MyraidPro',
    fontWeight: FontWeight.normal,
    fontSize: SysSize.small,
    color: ColorPlate.gray,
    inherit: true,
  );
}

class StText extends StatelessWidget {
  const StText({
    Key? key,
    this.text,
    this.style,
    this.defaultStyle,
    this.enableOffset = false,
    this.maxLines,
  }) : super(key: key);

  const StText.small(
    String text, {
    Key? key,
    TextStyle? style,
    bool? enableOffset,
    int? maxLines,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.small,
          enableOffset: enableOffset,
          maxLines: maxLines,
        );

  const StText.normal(
    String text, {
    Key? key,
    TextStyle? style,
    bool? enableOffset,
    int? maxLines,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.normal,
          enableOffset: enableOffset,
          maxLines: maxLines,
        );

  const StText.big(
    String text, {
    Key? key,
    TextStyle? style,
    bool? enableOffset,
    int? maxLines,
  }) : this(
          key: key,
          text: text,
          style: style,
          defaultStyle: StandardTextStyle.big,
          enableOffset: enableOffset,
          maxLines: maxLines,
        );
  final String? text;
  final TextStyle? style;
  final TextStyle? defaultStyle;
  final bool? enableOffset;
  final int? maxLines;

  double get offset {
    // if (!isAscii) {
    //   return 0;
    // }
    if (enableOffset != true) {
      return 0;
    }
    if (defaultStyle != null) {
      return (defaultStyle?.fontSize ?? 0) * 2 / 10;
    }
    if (style != null) {
      return (style?.fontSize ?? 0) * 2 / 10;
    }
    return 0;
  }

  bool isAscii(String str) {
    for (final int unit in str.codeUnits) {
      if (unit > 0xff) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final String finalText = text!;
    final bool hasOffset = isAscii(finalText);
    return Container(
      // fix font offset, if it's chinese, it should be zero
      padding: EdgeInsets.only(top: hasOffset ? offset : 0),
      child: DefaultTextStyle(
        style: defaultStyle!,
        child: Text(
          finalText,
          maxLines: maxLines ?? 5,
          style: style,
        ),
      ),
    );
  }
}
