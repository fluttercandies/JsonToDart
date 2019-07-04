String stringFormat(String format, List<dynamic> args) {
  if (format == null || format == "") return format;
  if (args != null) {
    String result = format;
    for (var i = 0; i < args.length; i++) {
      result = result.replaceAll("{$i}", "${args[i]}");
    }
    return result;
  }
  return format;
}
