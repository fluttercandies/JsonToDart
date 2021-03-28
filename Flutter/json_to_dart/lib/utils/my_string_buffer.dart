class MyStringBuffer {
  final StringBuffer _buffer = StringBuffer();

  int get length => _buffer.length;

  void writeLine(String? value) {
    _buffer.write('\n');
    _buffer.write(value);
  }

  void write(String value) {
    _buffer.write(value);
  }

  @override
  String toString() {
    return _buffer.toString();
  }
}
