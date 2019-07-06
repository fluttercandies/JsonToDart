import 'dart:convert';
import 'package:json_to_dart_library/json_to_dart_library.dart';
import 'package:json_to_dart/src/utils/local_storage.dart';

class ConfigHelper {
  static const key = "JsonToDartConfig";
  static final ConfigHelper _singleton =  ConfigHelper._internal();

  factory ConfigHelper() {
    return _singleton;
  }

  ConfigHelper._internal() {
 
  }


  Config get config => appConfig;

  void save() {
    LocalStorage.setItem(key, json.encode(config));
  }

  void initialize() {
    var value = LocalStorage.getItem(key);
    if (!isNullOrWhiteSpace(value)) {
      appConfig = Config.fromJson(json.decode(value));
    }
  }
}
