![](https://github.com/fluttercandies/JsonToDart/blob/master/UWP/Assets/Wide310x150Logo.scale-400.png)

功能最全面的 Json 转换 Dart 的工具，支持 Windows，Mac，Web。

Language: [English](README.md) | 中文简体
- [下载](#下载)
- [使用](#使用)
  - [格式化](#格式化)
  - [设置](#设置)
    - [数据保护](#数据保护)
    - [数组保护](#数组保护)
    - [遍历数组次数](#遍历数组次数)
    - [属性命名](#属性命名)
    - [属性排序](#属性排序)
    - [添加保护方法](#添加保护方法)
    - [空安全](#空安全)
    - [智能可空](#智能可空)
    - [文件头信息](#文件头信息)
    - [属性只读](#属性只读)
    - [可空](#可空)
  - [多语言](#多语言)
  - [修改类信息](#修改类信息)
  - [生成Dart](#生成dart)

# 下载

Github下载速度太慢，为了方便大家下载，特意在gitee也创建了下载地址。

[Flutter for Windows](https://gitee.com/zmtzawqlp/JsonToDart/releases/)

[Flutter for Macos](https://gitee.com/zmtzawqlp/JsonToDart/releases/)

[Flutter for Web](https://fluttercandies.github.io/JsonToDartFlutterWeb/)

[Flutter for Web(Gitee)](https://zmtzawqlp.gitee.io/jsontodartflutterweb)

[UWP 微软商店](https://www.microsoft.com/store/apps/9NBRW9451QSR) 功能未同步，以后会替换成 [Flutter for UWP](https://github.com/flutter/flutter/issues/14967)

# 使用

## 格式化

点击格式化按钮，将 Json 转换为右边可视化的 Dart 类结构

## 设置
### 数据保护

大家一定会有被服务端坑的时候吧？ 不按规定好了的数据类型传值，导致 Json 整个解析失败。

打开这个开关，就会在获取数据的时候加一层保护，代码如下

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

你也可以重写 [FFConvert.convert] 来处理特殊的情况，比如
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

### 数组保护

在循环数组的时候，一个出错，导致 Json 整个解析失败的情况，大家遇到过吧？

打开这个开关，将对每一次循环解析进行保护，代码如下

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

### 遍历数组次数

在服务器返回的数据中，有时候数组里面不是每一个元素都带有全部的属性，

如果只检查第一个话，会存在属性丢失的情况

你可以通过多次循环来避免丢失属性

选项有1，20，99

99就代表循环全部进行检查

### 属性命名

属性命名规范选项：保持原样，驼峰式命名小驼峰，帕斯卡命名大驼峰，匈牙利命名下划线

[Dart 命名规范](https://dart.dev/guides/language/effective-dart/style)

Dart 官方推荐 驼峰式命名小驼峰

### 属性排序

对属性进行排序

排序选项： 保持原样，升序排列，降序排序

### 添加保护方法

是否添加保护方法，数据保护/数组保护的方法。
第一次使用的时候开启就可以了，你可以把方法提出去，后面生成 Dart 就没有必要每个文件里面都包含这2个方法。

### 空安全

打开空安全，将生成空安全代码。

### 智能可空
打开智能可空, 所有为null的字段和数组丢失属性将会自动勾选可空

### 文件头信息

可以在这里添加 Copyright，Improt dart，创建人信息等等，支持[Date yyyy MM-dd]来生成时间，Date 后面为日期格式。

比如[Date yyyy MM-dd] 会将你生成Dart代码的时间按照 yyyy MM-dd 的格式生成对应时间

### 属性只读

点击格式化之后，右边会显示可视化的 Dart 类结构，在顶部会有下拉选项

选项：none，final
### 可空

在空安全打开的前提，设置属性是否可以为空。

## 多语言

支持中文简体，中文繁体和英文。

## 修改类信息

点击格式化之后，右边会显示可视化的 Dart 类结构。

第一列为在 Json 中对应的key

第二列为属性类型/类的名字。如果是类名，会用黄色背景提示

第三列是属性的名字

输入项如果为空，会报红提示

## 生成Dart

做好设置之后，点击生成按钮，左边就会生成 Json 对于的 Dart 代码，并且提示成功，代码自动复制到剪切板。

