import 'package:flutter/material.dart';
import 'package:json_to_dart_library/json_to_dart_library.dart';

class JsonTreeItem extends StatefulWidget {
  final ExtendedObject object;
  final ExtendedProperty property;
  final bool isArray;
  final bool isObject;
  final int depth;
  final bool isArrayOject;
  JsonTreeItem(this.object, this.property,
      {Key key,
      this.isArray = false,
      this.isObject = false,
      this.depth = 0,
      this.isArrayOject = false})
      : super(key: key);
  @override
  _JsonTreeItemState createState() => _JsonTreeItemState();
}

class _JsonTreeItemState extends State<JsonTreeItem> {
  @override
  Widget build(BuildContext context) {
    var finalDepth = widget.object.depth + widget.depth + 1;

    var object = widget.object;
    var property = widget.property;

    double w = 20.0;

    List<Widget> rowItems = List<Widget>();

    rowItems.add(Expanded(
      flex: 3,
      child: Container(
        margin: EdgeInsets.only(left: finalDepth * w),
        child: Text(widget.isArrayOject
            ? DartType.object.toString().replaceAll("DartType.", "")
            : widget.property.key),
      ),
    ));

    if (widget.isArray) {
      if (object.objectKeys.containsKey(property.key)) {
        var oject = object.objectKeys[property.key];
        var typeString = property.getTypeString(className: oject.className);
        List<String> ss;
        String start;
        String end;
        if (oject.className != "") {
          typeString = typeString.replaceAll("<${oject.className}>", "<>");
        }

        ss = typeString.split("<>");
        start = ss[0] + "<";
        end = ">" + ss[1];

        rowItems.add(Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              padding: EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Colors.black, width: 1.0))),
              child: Row(
                children: <Widget>[
                  Text(start),
                  StreamBuilder(
                    builder: (_, snapshot) {
                      return Text(snapshot.data);
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
              padding: EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Colors.black, width: 1.0))),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  property.getTypeString(),
                ),
              ),
            )));
      }
    } else if (widget.isObject) {
      rowItems.add(Expanded(
        flex: 1,
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.only(left: 8.0),
          decoration: BoxDecoration(
              color: isNullOrWhiteSpace((property as ExtendedObject).className)
                  ? Colors.red
                  : Colors.yellow,
              border:
                  Border(left: BorderSide(color: Colors.black, width: 1.0))),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            controller: TextEditingController()
              ..text = (property as ExtendedObject).className,
            onChanged: (value) {
              var oldValue = (property as ExtendedObject).className;
              (property as ExtendedObject).className = value;
              if (value != oldValue &&
                  (isNullOrWhiteSpace(value) || isNullOrWhiteSpace(oldValue))) {
                setState(() {});
              }
            },
          ),
        ),
      ));
    } else {
      rowItems.add(Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.only(left: 8.0),
          decoration: BoxDecoration(
              border:
                  Border(left: BorderSide(color: Colors.black, width: 1.0))),
          child: DropdownButton(
              onChanged: (value) {
                setState(() {
                  property.type = value;
                });
              },
              underline: Container(),
              value: property.type,
              items: DartType.values
                  .map<DropdownMenuItem>((f) => DropdownMenuItem(
                        value: f,
                        child: Text(f.toString().replaceAll("DartType.", "")),
                      ))
                  .toList()),
        ),
      ));
    }

    if (finalDepth > 0 && !widget.isArrayOject) {
      rowItems.add(Expanded(
          flex: 1,
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
                color: isNullOrWhiteSpace(property.name) ? Colors.red : null,
                border:
                    Border(left: BorderSide(color: Colors.black, width: 1.0))),
            child: TextField(
              controller: TextEditingController()..text = property.name,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (value) {
                var oldValue = property.name;
                property.name = value;
                if (value != oldValue &&
                    (isNullOrWhiteSpace(value) ||
                        isNullOrWhiteSpace(oldValue))) {
                  setState(() {});
                }
              },
            ),
          )));
    } else {
      rowItems.add(Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey,
          )));
    }

    if (finalDepth > 0 && !widget.isArrayOject) {
      rowItems.add(Expanded(
        flex: 1,
        child: Container(
          padding: EdgeInsets.only(left: 8.0),
          decoration: BoxDecoration(
              border:
                  Border(left: BorderSide(color: Colors.black, width: 1.0))),
          child: DropdownButton(
              onChanged: (value) {
                setState(() {
                  property.propertyAccessorType = value;
                });
              },
              underline: Container(),
              value: property.propertyAccessorType,
              items: PropertyAccessorType.values
                  .map<DropdownMenuItem>((f) => DropdownMenuItem(
                        value: f,
                        child: Text(f
                            .toString()
                            .replaceAll("PropertyAccessorType.", "")),
                      ))
                  .toList()),
        ),
      ));
    } else {
      rowItems.add(Expanded(flex: 1, child: Container(color: Colors.grey)));
    }

    return Container(
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 1.0))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: rowItems,
      ),
    );
  }
}
