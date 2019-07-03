import 'package:json_to_dart/src/models/config.dart';
class ConfigHelper {
  static final ConfigHelper _singleton = new ConfigHelper._internal();

  factory ConfigHelper() {
    return _singleton;
  }

  ConfigHelper._internal() {
    _config = Config();
  }

  // static ConfigHelper _instance = new ConfigHelper._();
  // static ConfigHelper get Instance {
  //   return _instance;
  // }

  // ConfigHelper._() {
  //   _config = Config();
  // }
  Config _config;
  Config get config => _config;
}
