![](https://github.com/fluttercandies/JsonToDart/blob/master/UWP/Assets/Wide310x150Logo.scale-400.png)

[功能最全面的Json转换Dart的工具](https://juejin.im/post/5d1463245188255d0d2f5c81)，使用[UWP](https://baike.so.com/doc/23718184-24274055.html),[WPF](https://baike.so.com/doc/2917373-3078588.html)和[Silverlight](https://baike.so.com/doc/5402730-5640416.html)开发，支持桌面和Web。

有任何问题可以提Issue 或者 

加入QQ群181398081询问

- [下载安装](#%E4%B8%8B%E8%BD%BD%E5%AE%89%E8%A3%85)
  - [UWP(Windows10)](#UWPWindows10)
  - [WPF(Windows7/Windows8)](#WPFWindows7Windows8)
  - [Silverlight(Web)](#SilverlightWeb)
- [使用](#%E4%BD%BF%E7%94%A8)
  - [格式化](#%E6%A0%BC%E5%BC%8F%E5%8C%96)
  - [更多设置](#%E6%9B%B4%E5%A4%9A%E8%AE%BE%E7%BD%AE)
    - [数据类型全方位保护](#%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B%E5%85%A8%E6%96%B9%E4%BD%8D%E4%BF%9D%E6%8A%A4)
    - [数组全方位保护](#%E6%95%B0%E7%BB%84%E5%85%A8%E6%96%B9%E4%BD%8D%E4%BF%9D%E6%8A%A4)
    - [遍历数组次数](#%E9%81%8D%E5%8E%86%E6%95%B0%E7%BB%84%E6%AC%A1%E6%95%B0)
    - [属性命名](#%E5%B1%9E%E6%80%A7%E5%91%BD%E5%90%8D)
    - [属性排序](#%E5%B1%9E%E6%80%A7%E6%8E%92%E5%BA%8F)
    - [添加保护方法](#%E6%B7%BB%E5%8A%A0%E4%BF%9D%E6%8A%A4%E6%96%B9%E6%B3%95)
    - [文件头部信息](#%E6%96%87%E4%BB%B6%E5%A4%B4%E9%83%A8%E4%BF%A1%E6%81%AF)
    - [属性访问器类型](#%E5%B1%9E%E6%80%A7%E8%AE%BF%E9%97%AE%E5%99%A8%E7%B1%BB%E5%9E%8B)
  - [修改json类信息](#%E4%BF%AE%E6%94%B9json%E7%B1%BB%E4%BF%A1%E6%81%AF)
  - [生成Dart](#%E7%94%9F%E6%88%90Dart)


# 下载安装
## UWP(Windows10)

Windows10 用户

考虑到应用商店经常大姨妈，就没有上传到商店了，大家到下面地址下载安装

[下载地址](https://github.com/fluttercandies/JsonToDart/tree/master/Release/windows/c%23/windows10)

下载好安装包，解压。

第一次安装，需要安装证书，请按照下图，使用PowerShell打开Add-AppDevPackage.ps1，一路接受就安装完毕

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/UWP安装1.png)

后面如果工具有更新，可以下载最新的，然后点击FlutterCandiesJsonToDart_x.0.x.0_x86_x64.appxbundle 安装

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/UWP安装2.png)

## WPF(Windows7/Windows8)

Windows7/Windows8 用户

[下载地址](https://github.com/fluttercandies/JsonToDart/tree/master/Release/windows/c%23/windows7)

下载解压，点击setup.exe安装

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/WPF安装.png)

## Silverlight(Web)

[不带字体文件Json To Dart地址](https://fluttercandies.github.io/JsonToDart)如果出现乱码，请使用下面地址

[带字体文件Json To Dart地址](https://fluttercandies.github.io/JsonToDartWeb)
由于中文字体问题，包含了中文字体文件，第一次会比较久，请耐心等待

首先需要安装[Silverlight](https://www.microsoft.com/getsilverlight/get-started/install/default?reason=unsupportedbrowser&_helpmsg=ChromeVersionDoesNotSupportPlugins#sysreq)

Mac的用户下载Mac的，Windows用户下载Windows的

然后就是浏览器问题了，因为支持Silverlight的浏览器是有限的，除了Internet Explorer支持，以下版本的浏览器也支持.

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/浏览器.png)

Mac [Safari 12.0以下的可以尝试这样开启插件](https://www.cnblogs.com/qiumingshanshangjian/p/8413165.html)

Mac [Firefox](https://mac.filehorse.com/download-firefox/7957/download/)这个版本能使用

[不带字体文件Json To Dart地址](https://fluttercandies.github.io/JsonToDart)如果出现乱码，请使用下面地址

[带字体文件Json To Dart地址](https://fluttercandies.github.io/JsonToDartWeb)
由于中文字体问题，包含了中文字体文件，第一次会比较久，请耐心等待

# 使用

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/界面.png)


左边是json的输入框以及最后Dart生成的代码，右边是生成的Json类的结构

## 格式化

点击格式化按钮，将json转换为右边可视化的json类结构

## 更多设置

设置会全部自动保存，一次设置终身受益

### 数据类型全方位保护

大家一定会有被服务端坑的时候吧？ 不按规定好了的数据类型传值，导致json整个解析失败。

打开这个开关，就会在获取数据的时候加一层保护，代码如下

```dart
dynamic convertValueByType(value, Type type, {String stack: ""}) {
  if (value == null) {
    debugPrint("$stack : value is null");
    if (type == String) {
      return "";
    } else if (type == int) {
      return 0;
    } else if (type == double) {
      return 0.0;
    } else if (type == bool) {
      return false;
    }
    return null;
  }

  if (value.runtimeType == type) {
    return value;
  }
  var valueS = value.toString();
  debugPrint("$stack : ${value.runtimeType} is not $type type");
  if (type == String) {
    return valueS;
  } else if (type == int) {
    return int.tryParse(valueS);
  } else if (type == double) {
    return double.tryParse(valueS);
  } else if (type == bool) {
    valueS = valueS.toLowerCase();
    var intValue = int.tryParse(valueS);
    if (intValue != null) {
      return intValue == 1;
    }
    return valueS == "true";
  }
}
```

### 数组全方位保护

在循环数组的时候，一个出错，导致json整个解析失败的情况，大家遇到过吧？

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

在服务器返回的数据中，有时候数组里面不是每一个Item都带有全部的属性，

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

是否添加保护方法。数据类型全方位保护/数组全方位保护 这2个开启的时候会生成方法。第一次使用的时候开启就可以了，你可以方法提出去，后面生成Dart就没有必要每个文件里面都要这2个方法了。

### 文件头部信息

可以在这里添加copyright，improt dart，创建人信息等等，支持[Date yyyy MM-dd]来生成时间，Date后面为日期格式。

比如[Date yyyy MM-dd] 会将你生成Dart代码的时间按照yyyy MM-dd的格式生成对应时间

### 属性访问器类型

点击格式化之后，右边会显示可视化的json类结构，在右边一列，就是属性访问器类型设置

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/属性访问器.png)

选项：默认，Final，Get，GetSet

顶部设置修改，下面子项都会修改。你也可以单独对某个属性进行设置。

## 修改json类信息

点击格式化之后，右边会显示可视化的json类结构。

第一列为在json中对应的key

第二列为属性类型/类的名字。如果是类名，会用黄色背景提示

第三列是属性的名字

输入选项如果为空，会报红提示

## 生成Dart

做好设置之后，点击生成Dart按钮，左边就会生成你想要的Dart代码，并且提示“Dart生成成功，已复制到剪切板”，可以直接复制到你的Dart文件里面
