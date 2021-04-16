import 'package:flutter/material.dart';
import 'package:json_to_dart/localizations/app_localizations.dart';
import 'package:json_to_dart/models/dart_object.dart';
import 'package:json_to_dart/models/dart_property.dart';
import 'package:json_to_dart/style/color.dart';
import 'package:json_to_dart/style/size.dart';
import 'package:json_to_dart/style/text.dart';
import 'package:json_to_dart/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
        String typeString = property.getTypeString(className: oject.className);
        List<String> ss;
        String start;
        String end;
        if (oject.className != '') {
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
                  StreamBuilder<String>(
                    builder: (_, AsyncSnapshot<String> snapshot) {
                      return Text(snapshot.data ?? '');
                    },
                    stream: oject.rebuildName.stream,
                    initialData: oject.className,
                  ),
                  Text(end)
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
          child: ClassNameTextField(property as DartObject),
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
          child: DartTypeDropdownButton(property),
        ),
      ));
    }

    if (finalDepth > 0 && !widget.isArrayOject) {
      rowItems.add(Expanded(flex: 1, child: PropertyNameTextField(property)));
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
              child: Selector<ConfigSetting, PropertyAccessorType>(
                builder: (BuildContext c, PropertyAccessorType value,
                    Widget? child) {
                  property.propertyAccessorType = value;
                  return PropertyAccessorTypeDropdownButton(property);
                },
                selector: (BuildContext c, ConfigSetting vm) =>
                    vm.propertyAccessorType,
              ),
            )
          : Container(
              color: ColorPlate.borderGray,
            ),
    ));

    rowItems.add(Selector<ConfigSetting, Tuple2<bool, bool>>(
      builder: (BuildContext c, Tuple2<bool, bool> value, Widget? child) {
        if (ConfigSetting().nullsafety) {
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
                    child: NullableCheckBox(property),
                  )
                : Container(
                    color: ColorPlate.borderGray,
                  ),
          );
        } else {
          property.updateNullable(true);
          return Container();
        }
      },
      selector: (BuildContext c, ConfigSetting vm) =>
          Tuple2<bool, bool>(vm.nullsafety, vm.nullable),
    ));

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

class ClassNameTextField extends StatefulWidget {
  const ClassNameTextField(this.property);

  final DartObject property;

  @override
  _ClassNameTextFieldState createState() => _ClassNameTextFieldState();
}

class _ClassNameTextFieldState extends State<ClassNameTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            Icons.label,
            size: SysSize.normal,
            color: isNullOrWhiteSpace(widget.property.className)
                ? Colors.red
                : Colors.blue,
          ),
        ),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            controller: TextEditingController()
              ..text = widget.property.className,
            onChanged: (String value) {
              final String oldValue = widget.property.className;
              widget.property.className = value;
              if (value != oldValue &&
                  (isNullOrWhiteSpace(value) || isNullOrWhiteSpace(oldValue))) {
                setState(() {});
              }
            },
          ),
        ),
      ],
    );
  }
}

class PropertyNameTextField extends StatefulWidget {
  const PropertyNameTextField(this.property);

  final DartProperty property;

  @override
  _PropertyNameTextFieldState createState() => _PropertyNameTextFieldState();
}

class _PropertyNameTextFieldState extends State<PropertyNameTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        color: isNullOrWhiteSpace(widget.property.name) ? Colors.red : null,
        border: const Border(
          left: BorderSide(
            color: ColorPlate.borderGray,
            width: 1.0,
          ),
        ),
      ),
      child: TextField(
        controller: TextEditingController()..text = widget.property.name,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        onChanged: (String value) {
          final String oldValue = widget.property.name;
          widget.property.name = value;
          if (value != oldValue &&
              (isNullOrWhiteSpace(value) || isNullOrWhiteSpace(oldValue))) {
            setState(() {});
          }
        },
      ),
    );
  }
}

class NullableCheckBox extends StatefulWidget {
  const NullableCheckBox(this.property);

  final DartProperty property;

  @override
  _NullableCheckBoxState createState() => _NullableCheckBoxState();
}

class _NullableCheckBoxState extends State<NullableCheckBox> {
  @override
  Widget build(BuildContext context) {
    return StCheckBox(
      title: AppLocalizations.of(context).nullable,
      value: widget.property.nullable,
      onChanged: (bool value) {
        setState(() {
          widget.property.updateNullable(value);
        });
      },
    );
  }
}

class PropertyAccessorTypeDropdownButton extends StatefulWidget {
  const PropertyAccessorTypeDropdownButton(this.property);

  final DartProperty property;

  @override
  _PropertyAccessorTypeDropdownButtonState createState() =>
      _PropertyAccessorTypeDropdownButtonState();
}

class _PropertyAccessorTypeDropdownButtonState
    extends State<PropertyAccessorTypeDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<PropertyAccessorType>(
        onChanged: (PropertyAccessorType? value) {
          if (widget.property.propertyAccessorType != value) {
            setState(() {
              widget.property.propertyAccessorType = value!;
            });
          }
        },
        underline: Container(),
        value: widget.property.propertyAccessorType,
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
  }
}

class DartTypeDropdownButton extends StatefulWidget {
  const DartTypeDropdownButton(this.property);

  final DartProperty property;

  @override
  _DartTypeDropdownButtonState createState() => _DartTypeDropdownButtonState();
}

class _DartTypeDropdownButtonState extends State<DartTypeDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<DartType>(
      onChanged: (DartType? value) {
        if (widget.property.type != value) {
          setState(() {
            widget.property.type = value!;
          });
        }
      },
      underline: Container(),
      value: widget.property.type == DartType.Null
          ? DartType.Object
          : widget.property.type,
      items: DartType.values
          .where((DartType e) => e != DartType.Null)
          .map<DropdownMenuItem<DartType>>(
              (DartType f) => DropdownMenuItem<DartType>(
                    value: f,
                    child: Text(f.text),
                  ))
          .toList(),
    );
  }
}
