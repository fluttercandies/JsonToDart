![](https://github.com/fluttercandies/JsonToDart/blob/master/UWP/Assets/Wide310x150Logo.scale-400.png)


The tool to convert json to dart code, support Windows，Mac，Web。

Language: English | [中文简体](README-ZH.md)
- [Download](#download)
- [Use](#use)
  - [Format](#format)
  - [Setting](#setting)
    - [Data Protection](#data-protection)
    - [Array Protection](#array-protection)
    - [Traverse Array Count](#traverse-array-count)
    - [Property Rule](#property-rule)
    - [Order Property](#order-property)
    - [Add Method](#add-method)
    - [NullSafety](#nullsafety)
    - [Smart NullAble](#smart-nullable)
    - [File Header](#file-header)
    - [Property Readonly](#property-readonly)
    - [Nullable](#nullable)
  - [Localizations](#localizations)
  - [Edit Class Info](#edit-class-info)
  - [Generate](#generate)

# Download

[Flutter for Windows](https://github.com/fluttercandies/JsonToDart/releases/)

[Flutter for Macos](https://github.com/fluttercandies/JsonToDart/releases/)

[Flutter for Web](https://fluttercandies.github.io/JsonToDart/)

[Flutter for Web(Gitee)](https://zmtzawqlp.gitee.io/jsontodartflutterweb)

[Microsoft Store](https://www.microsoft.com/store/apps/9NBRW9451QSR) The function is not ，it will replace with  [Flutter for UWP](https://github.com/flutter/flutter/issues/14967) in the future.

# Use

## Format

Click Format button, it will convert the Json string into Dart class structure.
## Setting
### Data Protection

 It will protect data when convert data as T safety.

```dart
class FFConvert {
  FFConvert._();
  static T? Function<T extends Object?>(dynamic value) convert =
      <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  };
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}
```

you can override [FFConvert.convert] to handle special case.
``` dart
  FFConvert.convert = <T extends Object?>(dynamic value) {
    if (value == null) {
      return null;
    }
    final dynamic output = json.decode(value.toString());
    if (<int>[] is T && output is List<dynamic>) {
      return output.map<int?>((dynamic e) => asT<int>(e)).toList() as T;
    } else if (<String, String>{} is T && output is Map<dynamic, dynamic>) {
      return output.map<String, String>((dynamic key, dynamic value) =>
          MapEntry<String, String>(key.toString(), value.toString())) as T;
    } else if (const TestMode() is T && output is Map<dynamic, dynamic>) {
      return TestMode.fromJson(output) as T;
    }

    return json.decode(value.toString()) as T?;
  };
```

### Array Protection

It can protect your array in case of one has some error.

```dart
void tryCatch(Function f) {
  try {
    f?.call();
  } catch (e, stack) {
    debugPrint("$e");
    debugPrint("$stack");
  }
}
```

### Traverse Array Count

The first object may be not has all properties.

We can slove it by setting traverse array count. It will traverse the array and merge the object.

1, 20, and 99 options are provided.

99 means traverse all of the array.

### Property Rule

none，camel case，pascal，hungarian notation

[Dart rule](https://dart.dev/guides/language/effective-dart/style)

camel case is recommended.

### Order Property

none，ascending，descending
### Add Method

Whether add [Data Protection] and [Array Protection].
In fact, you only need it at first time then extract it into your code and import it. 
### NullSafety

Support to generate null-safety code.

### File Header

You can add copyright,dart code, creator into here. support [Date yyyy MM-dd] format to generate time.

### Property Readonly

none，final options are provided.
### Nullable

You can set nullable if you are enable null-saftey.

### Smart Nullable
When smart nullable is checked, all null fields and missing properties of the array will be automatically nullable.

## Localizations

zh_hans，zh_hant and en are support.

## Edit Class Info

 Dart class structure are shown at right.

First column is the key in Json.

Second column is Property type or Class name. Yellow background will show if it is Class.

Third column is property name.

It will show red background if something is empty.

## Generate

Click generate button, Dart code will generate at left side. Dart code will set into the clipboard.


