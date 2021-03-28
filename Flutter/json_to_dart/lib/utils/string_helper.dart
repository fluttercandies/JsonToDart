String stringFormat(String format, List<String>? args) {
  if (format == '') {
    return format;
  }
  if (args != null) {
    String result = format;
    for (int i = 0; i < args.length; i++) {
      result = result.replaceAll('{$i}', args[i]);
    }
    return result;
  }
  return format;
}
