import 'package:dartx/dartx.dart';
import 'package:json_to_dart/models/dart_object.dart';
import 'package:json_to_dart/models/dart_property.dart';
import 'package:json_to_dart/utils/extension.dart';

final Set<String> symbolSet = <String>{' ', '.', '/', '\\', '-'};

/// <summary>
/// abcAbcaBc->abc_abca_bc
/// </summary>
/// <param name="name"></param>
/// <returns></returns>
String underScoreName(String name) {
  if (name.isNullOrEmpty) {
    return '';
  }

  final StringBuffer result = StringBuffer();

  for (final String symbol in symbolSet) {
    name = name.replaceAll(symbol, '_');
  }

  result.write(name.substring(0, 1).toLowerCase());
  for (int i = 1; i < name.length; i++) {
    final String temp = name[i];
    if (RegExp('[A-Z]').hasMatch(temp)) {
      result.write('_');
    }
    result.write(temp.toLowerCase());
  }

  return result.toString();
}

/// <summary>
/// abc_abca_bc->abcAbcaBc
/// </summary>
/// <param name="name"></param>
/// <returns></returns>

String camelName(String name, {bool firstCharLowerCase = true}) {
  final StringBuffer result = StringBuffer();
  if (name.isNullOrEmpty) {
    return '';
  }
  for (final String symbol in symbolSet) {
    name = name.replaceAll(symbol, '_');
  }

  final List<String> camels = name.split('_');
  for (final String camel in camels) {
    if (result.length == 0 && firstCharLowerCase) {
      result.write(camel.toLowerCase());
    } else {
      if (!name.isNullOrEmpty) {
        result.write(camel.substring(0, 1).toUpperCase());
        result.write(camel.substring(1).toLowerCase());
      }
    }
  }

  return result.toString();
}

/// <summary>
/// abc_abca_bc->AbcAbcaBc
/// </summary>
/// <param name="name"></param>
/// <returns></returns>
String upcaseCamelName(String name) {
  return camelName(name, firstCharLowerCase: false);
}

String correctName(
  String name, {
  bool isClassName = false,
  DartProperty? dartProperty,
}) {
  if (name.isEmpty) {
    return name;
  }

  String out = '';
  for (int i = 0; i < name.length; i++) {
    final String char = name[i];
    if (char == '_' ||
        (out.isEmpty ? RegExp('[a-zA-Z]') : RegExp('[a-zA-Z0-9]'))
            .hasMatch(char)) {
      out += char;
    }
  }

  if (out.isEmpty) {
    out = isClassName ? 'TestClass' : 'testProperty';
  } else if (isClassName && classNameKeyWord.contains(out)) {
    out = out.uid;
  } else if (propertyKeyWord.contains(out)) {
    out = out.uid;
  }

  // avoid property as following:
  // int int;
  // Test Test;
  // double double;
  // List List;
  // List<int> int;
  if (dartProperty != null) {
    if (dartProperty is DartObject && dartProperty.className.value == out) {
      out = out.uid;
    } else if (dartProperty.value is List) {
      if (out == 'List') {
        out = out.uid;
      } else if (dartProperty.getTypeString().contains('<$out>')) {
        out = out.uid;
      }
    } else if (dartProperty.getBaseTypeString() == out) {
      out = out.uid;
    }
  }

  return out;
}

/// https://dart.dev/guides/language/language-tour#keywords
// List<String> dartKeyWords = <String>[

// 'abstract','else','import' ,	'show',
//  'as','enum','in'	,'static',
// 'assert',	'export' ,'interface' ,	'super',
// 'async' ,	'extends',	'is',	'switch',
// await 3	extension 2	late 2	sync 1
// break	external 2	library 2	this
// case	factory 2	mixin 2	throw
// catch	false	new	true
// class	final	null	try
// const	finally	on 1	typedef 2
// continue	for	operator 2	var
// covariant 2	Function 2	part 2	void
// default	get 2	required 2	while
// deferred 2	hide 1	rethrow	with
// do	if	return	yield 3
// dynamic 2	implements 2	set 2
// ];

List<String> propertyKeyWord = <String>[
  'else',
  'enum',
  'in',
  'assert',
  'super',
  'extends',
  'is',
  'switch',
  'break',
  'this',
  'case',
  'throw',
  'catch',
  'false',
  'new',
  'true',
  'class',
  'final',
  'null',
  'try',
  'const',
  'finally',
  'on',
  'typedef',
  'continue',
  'for',
  'operator',
  'var',
  'covariant',
  'Function',
  'part',
  'void',
  'default',
  'get',
  'required',
  'while',
  'deferred',
  'hide',
  'rethrow',
  'with',
  'do',
  'if',
  'return',
  'yield',
  'dynamic',
  'implements',
  'set',
];

List<String> classNameKeyWord = <String>[
  'abstract',
  'else',
  'import',
  'as',
  'enum',
  'in',
  'static',
  'assert',
  'export',
  'interface',
  'super',
  'extends',
  'is',
  'switch',
  'extension',
  'late',
  'break',
  'external',
  'library',
  'this',
  'case',
  'factory',
  'mixin',
  'throw',
  'catch',
  'false',
  'new',
  'true',
  'class',
  'final',
  'null',
  'try',
  'const',
  'finally',
  'typedef',
  'continue',
  'for',
  'operator',
  'var',
  'covariant',
  'part',
  'void',
  'default',
  'get',
  'required',
  'while',
  'deferred',
  'rethrow',
  'with',
  'do',
  'if',
  'return',
  'dynamic',
  'implements',
  'set',
  'List',
  'Map'
];
