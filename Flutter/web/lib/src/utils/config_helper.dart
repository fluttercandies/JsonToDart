import 'dart:convert';

import 'package:json_to_dart/src/models/config.dart';
import 'package:json_to_dart/src/utils/camel_under_score_converter.dart';
import 'package:json_to_dart/src/utils/local_storage.dart';

class ConfigHelper {
  static const key = "JsonToDartConfig";
  static final ConfigHelper _singleton = new ConfigHelper._internal();

  factory ConfigHelper() {
    return _singleton;
  }

  ConfigHelper._internal() {
    _config = Config();
  }

  Config _config;
  Config get config => _config;

  void save() {
    LocalStorage.setItem(key, json.encode(_config));
  }

  void initialize() {
    var value = LocalStorage.getItem(key);
    if (!isNullOrWhiteSpace(value)) {
      _config = Config.fromJson(json.decode(value));
    }
  }
}
