import 'dart:convert';
import 'dart:io';

import 'package:json_to_dart/src/models/config.dart';

class ConfigHelper {
  static const String key="JsonToDartConfig.txt";
  static final ConfigHelper _singleton = new ConfigHelper._internal();

  factory ConfigHelper() {
    return _singleton;
  }

  ConfigHelper._internal() {
    _config = Config();
  }

  Config _config;
  Config get config => _config;

  void initialize() {
    var currentDirectory = Directory.current;

    File file = File(
        "${currentDirectory.uri.toFilePath(windows: Platform.isWindows)}$key");
    if (!file.existsSync()) {
      file.createSync();
      file.writeAsStringSync(json.encode(config));
    } else {
      String content = file.readAsStringSync();
      if (content != null && content != "") {
        _config = Config.fromJson(json.decode(content));
      }
    }
  }

  void save() {
    var currentDirectory = Directory.current;
    File file = File(
        "${currentDirectory.uri.toFilePath(windows: Platform.isWindows)}$key");
    if (file.existsSync()) {
      file.writeAsStringSync(json.encode(config));
    }
  }
}
