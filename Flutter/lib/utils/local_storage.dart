@JS()
library local_storage;

import 'package:js/js.dart';

@JS()
external void _putValue(key, value);

@JS()
external String _getValue(key);

@JS()
external void _clear();

@JS()
external void _removeValue(key);

class LocalStorage {
  static void setItem(String key, String value) {
    _putValue(key, value);
  }

  static String getItem(String key) {
    return _getValue(key);
  }

  static void clear() {
    _clear();
  }

  static void removeValue(key) {
    _removeValue(key);
  }
}
