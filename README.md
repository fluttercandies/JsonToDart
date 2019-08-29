![](https://github.com/fluttercandies/JsonToDart/blob/master/UWP/Assets/Wide310x150Logo.scale-400.png)

[功能最全面的Json转换Dart的工具](https://juejin.im/post/5d1463245188255d0d2f5c81)，支持Windows，Mac，Web以及Linux。

相关：
- [uwp](https://baike.so.com/doc/23718184-24274055.html)
- [wpf](https://baike.so.com/doc/2917373-3078588.html)
- [silverlight](https://baike.so.com/doc/5402730-5640416.html)
- [flutter](https://github.com/flutter/flutter)
- [flutter-desktop](https://github.com/google/flutter-desktop-embedding)
- [flutter-web](https://github.com/flutter/flutter_web)
- [go-flutter](https://github.com/go-flutter-desktop/go-flutter)
- [go](https://github.com/golang/go)
- [hover](https://github.com/go-flutter-desktop/hover)

Flutter Candies qq群181398081

- [下载](#%e4%b8%8b%e8%bd%bd)
- [安装](#%e5%ae%89%e8%a3%85)
  - [UWP(Windows10)](#uwpwindows10)
  - [WPF(Windows7/Windows8)](#wpfwindows7windows8)
  - [Silverlight(Web)](#silverlightweb)
  - [Flutter(Mac)](#fluttermac)
  - [Flutter(Windows_x64)](#flutterwindowsx64)
- [使用](#%e4%bd%bf%e7%94%a8)
  - [格式化](#%e6%a0%bc%e5%bc%8f%e5%8c%96)
  - [更多设置](#%e6%9b%b4%e5%a4%9a%e8%ae%be%e7%bd%ae)
    - [数据类型全方位保护](#%e6%95%b0%e6%8d%ae%e7%b1%bb%e5%9e%8b%e5%85%a8%e6%96%b9%e4%bd%8d%e4%bf%9d%e6%8a%a4)
    - [数组全方位保护](#%e6%95%b0%e7%bb%84%e5%85%a8%e6%96%b9%e4%bd%8d%e4%bf%9d%e6%8a%a4)
    - [遍历数组次数](#%e9%81%8d%e5%8e%86%e6%95%b0%e7%bb%84%e6%ac%a1%e6%95%b0)
    - [属性命名](#%e5%b1%9e%e6%80%a7%e5%91%bd%e5%90%8d)
    - [属性排序](#%e5%b1%9e%e6%80%a7%e6%8e%92%e5%ba%8f)
    - [添加保护方法](#%e6%b7%bb%e5%8a%a0%e4%bf%9d%e6%8a%a4%e6%96%b9%e6%b3%95)
    - [文件头部信息](#%e6%96%87%e4%bb%b6%e5%a4%b4%e9%83%a8%e4%bf%a1%e6%81%af)
    - [属性访问器类型](#%e5%b1%9e%e6%80%a7%e8%ae%bf%e9%97%ae%e5%99%a8%e7%b1%bb%e5%9e%8b)
  - [修改json类信息](#%e4%bf%ae%e6%94%b9json%e7%b1%bb%e4%bf%a1%e6%81%af)
  - [生成Dart](#%e7%94%9f%e6%88%90dart)

# 下载

| 平台    | 语言 | 描述                                                                                                    | 代码/安装包地址                                                                                                               |
| ------- | ---- | ------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| windows | C#   | uwp构建，运行环境windows10，x86/x64                                                                     | [windows-uwp.zip](https://github.com/fluttercandies/JsonToDart/releases)                                                      |
| windows | C#   | wpf构建，运行环境windows10/windows8/widnows7，x86/x64                                                   | [windows-wpf.zip](https://github.com/fluttercandies/JsonToDart/releases)                                                      |
| windows | dart | flutter构建, 使用[官方方式](https://github.com/google/flutter-desktop-embedding)编译,x64 ,debug版本     | [windows-x64-flutter.zip](https://github.com/fluttercandies/JsonToDart/releases)                                              |
| windows | dart | flutter构建, 使用[go-flutter](https://github.com/go-flutter-desktop/go-flutter)编译,x64 ,debug版本      | [windows-x64-go-flutter.zip](https://github.com/fluttercandies/JsonToDart/releases)                                           |
| mac     | dart | flutter构建,使用[go-flutter](https://github.com/go-flutter-desktop/go-flutter)编译(官方方式,未找到产物) | [mac-go-flutter.zip](https://github.com/fluttercandies/JsonToDart/releases)                                                   |
| web     | C#   | [silverlight](https://baike.so.com/doc/5402730-5640416.html)构建, 需要安装silverlight插件，有浏览器限制 | [网页地址](https://fluttercandies.github.io/JsonToDart)和[带字体文件网页地址](https://fluttercandies.github.io/JsonToDartWeb) |
| web     | dart | [flutter-web](https://github.com/flutter/flutter_web)构建                                               | [网页地址]( https://fluttercandies.github.io/JsonToDartFlutterWeb/)                                                           |
| linux   | dart | flutter构建, 使用官方方式编译，(没有环境测试，假装可以用)                                               | [代码地址](https://github.com/fluttercandies/JsonToDart/tree/master/Flutter/desktop)                                          |

# 安装
## UWP(Windows10)

Windows10 用户

考虑到应用商店经常大姨妈，就没有上传到商店了。

下载好安装包，解压。

第一次安装，需要安装证书，请按照下图，使用PowerShell打开Add-AppDevPackage.ps1，一路接受就安装完毕

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/UWP安装1.png)

后面如果工具有更新，可以下载最新的，然后点击FlutterCandiesJsonToDart_x.0.x.0_x86_x64.appxbundle 安装

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/UWP安装2.png)

## WPF(Windows7/Windows8)

Windows7/Windows8 用户

下载解压，点击setup.exe安装

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/WPF安装.png)

## Silverlight(Web)

带字体文件是因为可能有乱码，由于中文字体问题，包含了中文字体文件，第一次会比较久，请耐心等待

首先需要安装[Silverlight](https://www.microsoft.com/getsilverlight/get-started/install/default?reason=unsupportedbrowser&_helpmsg=ChromeVersionDoesNotSupportPlugins#sysreq)

Mac的用户下载Mac的，Windows用户下载Windows的

然后就是浏览器问题了，因为支持Silverlight的浏览器是有限的，除了Internet Explorer支持，以下版本的浏览器也支持.

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/浏览器.png)

Mac [Safari 12.0以下的可以尝试这样开启插件](https://www.cnblogs.com/qiumingshanshangjian/p/8413165.html)

Mac [Firefox](https://mac.filehorse.com/download-firefox/7957/download/)这个版本能使用

## Flutter(Mac)

go-flutter生成的产物是二进制程序，运行为exec，可以双击打开,
后由[低调大佬](https://github.com/CaiJingLong)测试打包[DMG](https://studygolang.com/articles/14480)，安装即可，注意在安全性与隐私中同意安装，具体如何打包可以查看[Go Flutter Desktop (二) go 二进制程序打包为 mac app(dmg)](https://www.kikt.top/posts/flutter/desktop/go-desktop-engine/flutter-go-desktop-2/)

## Flutter(Windows_x64)

flutter官方产物或者go-flutter产物为exe，点击exe启动

# 使用

![](https://github.com/fluttercandies/JsonToDart/blob/master/Image/界面.png)


左边是json的输入框以及最后Dart生成的代码，右边是生成的Json类的结构

## 格式化

点击格式化按钮，将json转换为右边可视化的json类结构

## 更多设置

设置会全部自动保存（flutter版本除外，需要手动保存），一次设置终身受益

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

在服务器返回的数据中，有时候数组里面不是每一个item都带有全部的属性，

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
