enum DartType {
  String,
  int,
  Object,
  bool,
  double,
  Null,
}

enum PropertyAccessorType {
  /// <summary>
  /// default
  /// </summary>
  none,

  /// <summary>
  /// final readonly
  /// </summary>
  final_,

  /// <summary>
  /// readonly
  /// </summary>
  //get_,

  /// <summary>
  /// get and set
  /// </summary>
  //getSet,
}

enum PropertyNamingConventionsType {
  /// <summary>
  /// default
  /// </summary>
  none,

  /// <summary>
  /// camelCase
  /// </summary>
  camelCase,

  /// <summary>
  /// pascal
  /// </summary>
  pascal,

  /// <summary>
  /// hungarianNotation
  /// </summary>
  hungarianNotation
}

enum PropertyNameSortingType {
  none,
  ascending,
  descending,
}

extension DartTypeE on DartType {
  String get text =>
      this == DartType.Null ? 'Object' : toString().replaceAll('DartType.', '');

  bool get isNull => this == DartType.Null;
}
