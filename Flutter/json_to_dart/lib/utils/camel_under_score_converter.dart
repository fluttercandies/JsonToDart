/// <summary>
/// abcAbcaBc->abc_abca_bc
/// </summary>
/// <param name="name"></param>
/// <returns></returns>
String underScoreName(String name) {
  if (isNullOrWhiteSpace(name)) {
    return '';
  }

  final StringBuffer result = StringBuffer();

  result.write(name.substring(0, 1).toLowerCase());
  for (int i = 1; i < name.length; i++) {
    final String temp = name[i];
    if (!isNullOrWhiteSpace(temp) &&
        temp != '_' &&
        int.tryParse(temp) == null &&
        (temp == temp.toUpperCase())) {
      result.write('_');
    }
    result.write(temp.toLowerCase());
  }

  return result.toString();
}

/// <summary>
/// abc_abca_bc->abcAbcaBc
/// </summary>
/// <param name="name"></param>
/// <returns></returns>

String camelName(String name) {
  final StringBuffer result = StringBuffer();
  if (isNullOrWhiteSpace(name)) {
    return '';
  }
  if (!name.contains('_')) {
    result.write(name.substring(0, 1).toLowerCase());
    result.write(name.substring(1));
    return result.toString();
  }
  final List<String> camels = name.split('_');
  for (final String camel in camels) {
    if (result.length == 0) {
      result.write(camel.toLowerCase());
    } else {
      if (!isNullOrWhiteSpace(name)) {
        result.write(camel.substring(0, 1).toUpperCase());
        result.write(camel.substring(1).toLowerCase());
      }
    }
  }

  return result.toString();
}

/// <summary>
/// abc_abca_bc->AbcAbcaBc
/// </summary>
/// <param name="name"></param>
/// <returns></returns>
String upcaseCamelName(String name) {
  final StringBuffer result = StringBuffer();
  if (isNullOrWhiteSpace(name)) {
    return '';
  }
  if (!name.contains('_')) {
    result.write(name.substring(0, 1).toUpperCase());
    result.write(name.substring(1));
    return result.toString();
  }
  final List<String> camels = name.split('_');
  for (final String camel in camels) {
    if (!isNullOrWhiteSpace(name)) {
      result.write(camel.substring(0, 1).toUpperCase());
      result.write(camel.substring(1).toLowerCase());
    }
  }

  return result.toString();
}

bool isNullOrWhiteSpace(String? value) {
  return value == null || value == '';
}
