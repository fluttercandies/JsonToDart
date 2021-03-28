import 'dart:collection';

class IList<T> extends ListBase<T> {
  final List<T> _list = <T>[];
  @override
  int get length => _list.length;
  @override
  set length(int value) {
    _list.length = value;
  }

  @override
  T operator [](int index) {
    return _list[index];
  }

  @override
  void operator []=(int index, T value) {
    _list[index] = value;
  }

  @override
  void add(T element) {
    _list.add(element);
  }
}
