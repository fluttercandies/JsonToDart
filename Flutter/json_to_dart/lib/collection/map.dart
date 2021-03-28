import 'dart:collection';

class IMap<K, V> extends MapBase<K, V> {
  final Map<K, V> _map = <K, V>{};
  @override
  V? operator [](Object? key) {
    return _map[key];
  }

  @override
  void operator []=(K key, V value) {
    _map[key] = value;
  }

  @override
  void clear() {
    _map.clear();
  }

  @override
  Iterable<K> get keys => _map.keys;

  @override
  V? remove(Object? key) {
    return _map.remove(key);
  }
}
