
import 'package:json_to_dart/src/models/config.dart';
class ConfigHelper {
  static final ConfigHelper _singleton = new ConfigHelper._internal();

  factory ConfigHelper() {
    return _singleton;
  }

  ConfigHelper._internal() {
    _config = Config();
  }

  Config _config;
  Config get config => _config;

  void save()
  {

  }

  void initialize()
  {
    
  }
}
