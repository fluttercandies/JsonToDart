/// <summary>
/// 驼峰转大写+下划线，abcAbcaBc->abc_abca_bc
/// </summary>
/// <param name="name"></param>
/// <returns></returns>
String underScoreName(String name) {
  if (IsNullOrWhiteSpace(name)) {
    return "";
  }

  StringBuffer result = new StringBuffer();

  result.write(name.substring(0, 1).toLowerCase());
  for (int i = 1; i < name.length; i++) {
    var temp = name[i];
    if ((temp == temp.toUpperCase())) {
      result.write("_");
    }
    result.write(temp.toLowerCase());
  }

  return result.toString();
}

/// <summary>
/// 下划线转驼峰，abc_abca_bc->abcAbcaBc
/// </summary>
/// <param name="name"></param>
/// <returns></returns>

String camelName(String name) {
  StringBuffer result = new StringBuffer();
  if (IsNullOrWhiteSpace(name)) {
    return "";
  }
  if (!name.contains("_")) {
    result.write(name.substring(0, 1).toLowerCase());
    result.write(name.substring(1));
    return result.toString();
  }
  List<String> camels = name.split('_');
  for (var camel in camels) {
    if (result.length == 0) {
      result.write(camel.toLowerCase());
    } else {
      result.write(camel.substring(0, 1).toUpperCase());
      result.write(camel.substring(1).toLowerCase());
    }
  }

  return result.toString();
}

/// <summary>
/// 下划线转首字母大写驼峰，abc_abca_bc->AbcAbcaBc
/// </summary>
/// <param name="name"></param>
/// <returns></returns>
String upcaseCamelName(String name) {
  StringBuffer result = new StringBuffer();
  if (IsNullOrWhiteSpace(name)) {
    return "";
  }
  if (!name.contains("_")) {
    result.write(name.substring(0, 1).toUpperCase());
    result.write(name.substring(1));
    return result.toString();
  }
  List<String> camels = name.split('_');
  for (var camel in camels) {
    if (!IsNullOrWhiteSpace(name)) {
      result.write(camel.substring(0, 1).toUpperCase());
      result.write(camel.substring(1).toLowerCase());
    }
  }

  return result.toString();
}

bool IsNullOrWhiteSpace(String value) {
  return value == null || value == "";
}
