import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_to_dart/models/dart_object.dart';
import 'package:json_to_dart/models/dart_property.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/size.dart';
import 'package:json_to_dart/style/text.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:json_to_dart/utils/extension.dart';

import '../models/config.dart';
import '../models/dart_object.dart';
import '../utils/enums.dart';
import '../widget/checkBox.dart';

Widget _emptyWidget = Expanded(
    flex: 1,
    child: Container(
      color: ColorPlate.borderGray,
    ));

class JsonTreeItem extends StatefulWidget {
  const JsonTreeItem(this.object, this.property,
      {Key? key,
      this.isArray = false,
      this.isObject = false,
      this.depth = 0,
      this.isArrayOject = false})
      : super(key: key);
  final DartObject object;
  final DartProperty property;
  final bool isArray;
  final bool isObject;
  final int depth;
  final bool isArrayOject;

  @override
  _JsonTreeItemState createState() => _JsonTreeItemState();
}

class _JsonTreeItemState extends State<JsonTreeItem> {
  @override
  Widget build(BuildContext context) {
    const Color borderColor = ColorPlate.borderGray;
    final int finalDepth = widget.object.depth + widget.depth + 1;

    final DartObject object = widget.object;
    final DartProperty property = widget.property;

    const double w = 10.0;

    final List<Widget> rowItems = <Widget>[];

    final String key = widget.isArrayOject
        ? DartType.Object.toString().replaceAll('DartType.', '')
        : widget.property.key;

    rowItems.add(Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.only(left: 8),
        margin: EdgeInsets.only(left: finalDepth * w),
        child: StText.normal(' ' * finalDepth + key),
      ),
    ));

    if (widget.isArray) {
      if (object.objectKeys.containsKey(property.key)) {
        final DartObject oject = object.objectKeys[property.key]!;
        String typeString =
            property.getTypeString(className: oject.className.value);
        List<String> ss;
        String start;
        String end;
        if (oject.className.value != '') {
          typeString = typeString.replaceAll('<${oject.className}>', '<>');
        }
        typeString = typeString.replaceAll('?', '');

        ss = typeString.split('<>');
        start = ss[0] + '<';
        end = '>' + ss[1];

        rowItems.add(Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              padding: const EdgeInsets.only(left: 8.0),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: borderColor,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(start),
                  Obx(() {
                    return Text(oject.className.value);
                  }),
                  Text(end),
                ],
              ),
            )));
      } else {
        rowItems.add(Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.only(left: 8.0),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: borderColor,
                    width: 1.0,
                  ),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  property.getTypeString().replaceAll('?', ''),
                ),
              ),
            )));
      }
    } else if (widget.isObject) {
      rowItems.add(Expanded(
        flex: 1,
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.only(left: 8.0),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: borderColor,
                width: 1.0,
              ),
            ),
          ),
          child: ClassNameTextField(
            property: property as DartObject,
          ),
        ),
      ));
    } else {
      rowItems.add(Expanded(
        flex: 1,
        child: Container(
          padding: const EdgeInsets.only(left: 8.0),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: borderColor, width: 1.0),
            ),
          ),
          child: DartTypeDropdownButton(property: property),
        ),
      ));
    }

    if (finalDepth > 0 && !widget.isArrayOject) {
      rowItems.add(
          Expanded(flex: 1, child: PropertyNameTextField(property: property)));
    } else {
      rowItems.add(_emptyWidget);
    }

    rowItems.add(Expanded(
      flex: 1,
      child: finalDepth > 0 && !widget.isArrayOject
          ? Container(
              padding: const EdgeInsets.only(left: 8.0),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: borderColor, width: 1.0),
                ),
              ),
              child: Obx(() {
                property.propertyAccessorType.value =
                    ConfigSetting().propertyAccessorType.value;
                return PropertyAccessorTypeDropdownButton(property: property);
              }))
          : Container(
              color: ColorPlate.borderGray,
            ),
    ));

    rowItems.add(Obx(() {
      if (ConfigSetting().nullsafetyObs.value) {
        return Expanded(
          flex: 1,
          child: finalDepth > 0 && !widget.isArrayOject
              ? Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: borderColor, width: 1.0),
                    ),
                  ),
                  child: NullableCheckBox(property: property),
                )
              : Container(
                  color: ColorPlate.borderGray,
                ),
        );
      } else {
        // property.nullable = true;
        // property.nullableObs.value = true;
        return Container(
          width: 0,
          height: 0,
        );
      }
    }));

    return Container(
      height: 50.0,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: rowItems,
      ),
    );
  }
}

class ClassNameTextField extends StatelessWidget {
  const ClassNameTextField({
    Key? key,
    required this.property,
  }) : super(key: key);
  final DartObject property;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Obx(() {
          return Tooltip(
            message: property.classError.join('\n'),
            child: Container(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.label,
                size: SysSize.normal,
                color: property.hasClassError ? Colors.red : Colors.blue,
              ),
            ),
          );
        }),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            controller: property.classNameTextEditingController,
            onChanged: (String value) {
              if (property.className.value != value) {
                property.className.value = value;
                property.updateError(property.className);
              }
            },
          ),
        ),
      ],
    );
  }
}

class PropertyNameTextField extends StatelessWidget {
  const PropertyNameTextField({Key? key, required this.property})
      : super(key: key);
  final DartProperty property;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Obx(() {
          if (property.hasPropertyError) {
            return Tooltip(
              message: property.propertyError.join('\n'),
              child: Container(
                padding: const EdgeInsets.only(right: 4),
                child: const Icon(
                  Icons.label,
                  size: SysSize.normal,
                  color: Colors.red,
                ),
              ),
            );
          }

          return Container();
        }),
        Expanded(
            child: TextField(
          controller: property.nameTextEditingController,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onChanged: (String value) {
            if (property.name.value != value) {
              property.name.value = value;
              property.updateError(property.name);
            }
          },
        )),
      ],
    );
  }
}

class NullableCheckBox extends StatelessWidget {
  const NullableCheckBox({
    Key? key,
    required this.property,
  }) : super(key: key);
  final DartProperty property;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return StCheckBox(
        title: appLocalizations.nullable,
        value: property.nullableObs.value,
        onChanged: (bool value) {
          property.nullable = value;
          property.nullableObs.value = value;
        },
      );
    });
  }
}

class PropertyAccessorTypeDropdownButton extends StatelessWidget {
  const PropertyAccessorTypeDropdownButton({
    Key? key,
    required this.property,
  }) : super(key: key);
  final DartProperty property;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButton<PropertyAccessorType>(
          onChanged: (PropertyAccessorType? value) {
            property.propertyAccessorType.value = value!;
          },
          underline: Container(),
          value: property.propertyAccessorType.value,
          items: PropertyAccessorType.values
              .where((PropertyAccessorType element) =>
                  element == PropertyAccessorType.none ||
                  element == PropertyAccessorType.final_)
              .map<DropdownMenuItem<PropertyAccessorType>>(
                  (PropertyAccessorType f) =>
                      DropdownMenuItem<PropertyAccessorType>(
                        value: f,
                        child: Text(f
                            .toString()
                            .replaceAll('PropertyAccessorType.', '')
                            .replaceAll('_', '')
                            .toLowerCase()),
                      ))
              .toList());
    });
  }
}

class DartTypeDropdownButton extends StatelessWidget {
  const DartTypeDropdownButton({
    Key? key,
    required this.property,
  }) : super(key: key);
  final DartProperty property;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DropdownButton<DartType>(
        onChanged: (DartType? value) {
          property.type.value = value!;
        },
        underline: Container(),
        value: property.type.value == DartType.Null
            ? DartType.Object
            : property.type.value,
        items: DartType.values
            .where((DartType e) => e != DartType.Null)
            .map<DropdownMenuItem<DartType>>(
                (DartType f) => DropdownMenuItem<DartType>(
                      value: f,
                      child: Text(f.text),
                    ))
            .toList(),
      );
    });
  }
}
