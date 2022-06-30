import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'zh_CN': {
      'hello': '你好 世界',
      "formatButtonLabel": "格式化",
      "generateButtonLabel": "生成",
      "settingButtonLabel": "设置",
      "classNameAssert": "{name} 的 Class 名字为空。",
      // "@classNameAssert": {
      //   "placeholders": {
      //     "name": {}
      //   }
      // },
      "propertyNameAssert": "{name}: 属性名字为空。",
      // "@propertyNameAssert": {
      //   "placeholders": {
      //     "name": {}
      //   }
      // },
      "formatErrorInfo": "格式化出错. 错误信息已复制到剪切板。",
      "illegalJson": "Json格式不正確",
      "timeFormatError": "时间格式不正确。",
      "generateSucceed": "Dart 代码生成成功，已复制到剪切板。",
      "generateFailed": "Dart 代码生成失败，错误信息已复制到剪切板。",
      "inputHelp": "请输入Json字符串，按格式化按钮。",
      "type": "类型",
      "name": "名字",
      "dataProtection": "数据保护",
      "arrayProtection": "数组保护",
      "traverseArrayCount": "数组循环次数",
      "nameRule": "名字规则",
      "original": "默认",
      "camelCase": "小驼峰",
      "pascal": "大驼峰",
      "hungarianNotation": "匈牙利命名法",
      "propertyOrder": "属性排序",
      "ascending": "升序",
      "descending": "降序",
      "addMethod": "添加保护方法",
      "fileHeader": "文件头信息",
      "fileHeaderHelp": "可以在这里添加 Copyright，导入 Dart 代码，创建人信息等等。支持[Date yyyy MM-dd]来生成时间，Date后面为日期格式.",
      "nullsafety": "空安全",
      "nullable": "可空",
      "smartNullable": "智能可空",
      "addCopyMethod":"添加复制方法",
      "duplicateClasses":"包含重复的类",
      "warning":"警告",
      "ok":"确认",
      "propertyCantSameAsClassName":"属性名不能为类名",
      "keywordCheckFailed": "'{name}' 是关键字!",
      // "@keywordCheckFailed": {
      //   "placeholders": {
      //     "name": {}
      //   }
      // },
      "propertyCantSameAsType": "属性名不能跟类型相同",
      "containsIllegalCharacters": "包含非法字符",
      "duplicateProperties":"属性名重复",
      "automaticCheck":"自动校验"
    },
    'en_US': {
      'hello': 'hellow world',
      "formatButtonLabel": "Format",
      "generateButtonLabel": "Generate",
      "settingButtonLabel": "Setting",
      "classNameAssert": "{name}'s class name is empty.",
      // "@classNameAssert": {
      //   "placeholders": {
      //     "name": {}
      //   }
      // },
      "propertyNameAssert": "{name}: property name is empty",
      // "@propertyNameAssert": {
      //   "placeholders": {
      //     "name": {}
      //   }
      // },
      "formatErrorInfo": "There is something wrong to format. The error has copied into Clipboard.",
      "illegalJson": "Illegal JSON format",
      "timeFormatError": "The format of time is not right.",
      "generateSucceed": "The dart code is generated successfully. It has copied into Clipboard.",
      "generateFailed": "The dart code is generated failed. The error has copied into Clipboard.",
      "inputHelp": "Please input your json string, and click Format button.",
      "type": "Type",
      "name": "Name",
      "dataProtection": "Data Protection",
      "arrayProtection": "Array Protection",
      "traverseArrayCount": "Traverse Array Count",
      "nameRule": "Name Rule",
      "original": "Original",
      "camelCase": "CamelCase",
      "pascal": "Pascal",
      "hungarianNotation": "Hungarian Notation",
      "propertyOrder": "Property Order",
      "ascending": "Ascending",
      "descending": "Descending",
      "addMethod": "Add Protection Method",
      "fileHeader": "File Header",
      "fileHeaderHelp": "You can add copyright,dart code, creator into here. support [Date yyyy MM-dd] format to generate time.",
      "nullsafety": "Null Safety",
      "nullable": "Nullable",
      "smartNullable": "Smart Nullable",
      "addCopyMethod":"Add Copy Method",
      "duplicateClasses":"There are duplicate classes",
      "warning":"Warning",
      "ok":"OK",
      "propertyCantSameAsClassName":"property can't the same as Class name",
      "keywordCheckFailed": "'{name}' is a key word!",
      // "@keywordCheckFailed": {
      //   "placeholders": {
      //     "name": {}
      //   }
      // },
      "propertyCantSameAsType": "property can't the same as Type",
      "containsIllegalCharacters": "contains illegal characters",
      "duplicateProperties":"There are duplicate properties",
      "automaticCheck":"Automatic Check"
    }
  };
}
