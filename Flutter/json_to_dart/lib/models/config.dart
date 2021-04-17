import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:json_to_dart/utils/enums.dart';
part 'config.g.dart';

/// flutter packages pub run build_runner build --delete-conflicting-outputs
@HiveType(typeId: TypeIds.appSetting)
class ConfigSetting extends Setting<ConfigSetting> with ChangeNotifier {
  factory ConfigSetting() => _appSetting;
  ConfigSetting._();
  static final ConfigSetting _appSetting = ConfigSetting._();

  @override
  Future<void> init({
    TypeAdapter<ConfigSetting>? adapter,
    ConfigSetting? defaultValue,
  }) async {
    Hive.registerAdapter(PropertyAccessorTypeAdapter());
    Hive.registerAdapter(PropertyNamingConventionsTypeAdapter());
    Hive.registerAdapter(PropertyNameSortingTypeAdapter());
    Hive.registerAdapter(LocaleAdapter());
    await super.init(adapter: ConfigSettingAdapter(), defaultValue: this);
  }

  @HiveField(0)
  bool addMethod = true;
  @HiveField(1)
  int column1Width = 2;
  @HiveField(2)
  int column2Width = 3;
  @HiveField(3)
  bool enableArrayProtection = false;
  @HiveField(4)
  bool enableDataProtection = false;
  @HiveField(5)
  String fileHeaderInfo = '';
  @HiveField(6)
  int traverseArrayCount = 1;
  @HiveField(7)
  PropertyNamingConventionsType propertyNamingConventionsType =
      PropertyNamingConventionsType.camelCase;

  PropertyAccessorType _propertyAccessorType = PropertyAccessorType.none;
  @HiveField(8)
  PropertyAccessorType get propertyAccessorType => _propertyAccessorType;
  @HiveField(8)
  set propertyAccessorType(PropertyAccessorType value) {
    if (_propertyAccessorType != value) {
      _propertyAccessorType = value;
      notifyListeners();
    }
  }

  @HiveField(9)
  PropertyNameSortingType propertyNameSortingType =
      PropertyNameSortingType.none;

  bool _nullsafety = false;
  @HiveField(10)
  bool get nullsafety => _nullsafety;
  @HiveField(10)
  set nullsafety(bool value) {
    if (_nullsafety != value) {
      _nullsafety = value;
      notifyListeners();
    }
  }

  bool _nullable = true;
  @HiveField(11)
  bool get nullable => _nullable;
  @HiveField(11)
  set nullable(bool value) {
    if (_nullable != value) {
      _nullable = value;
      notifyListeners();
    }
  }

  Locale _locale = const Locale.fromSubtags(languageCode: 'en');
  @HiveField(12)
  Locale get locale => _locale;
  @HiveField(12)
  set locale(Locale value) {
    if (_locale != value) {
      _locale = value;
      notifyListeners();
    }
  }

  bool _smartNullable = false;
  @HiveField(13)
  bool get smartNullable => _smartNullable;
  @HiveField(13)
  set smartNullable(bool value) {
    if (_smartNullable != value) {
      _smartNullable = value;
      notifyListeners();
    }
  }
}

class TypeIds {
  const TypeIds._();
  static const int appSetting = 0;
  static const int propertyNamingConventionsType = 1;
  static const int propertyAccessorType = 2;
  static const int propertyNameSortingType = 3;
  static const int localeType = 4;
}

class Setting<T extends HiveObject> extends HiveObject {
  @mustCallSuper
  Future<void> init({TypeAdapter<T>? adapter, T? defaultValue}) async {
    Hive.registerAdapter<T>(adapter!);
    final String tType = runtimeType.toString();
    final Box<T> box = await Hive.openBox<T>(tType);
    if ((box.isEmpty || box.getAt(0) == null) && defaultValue != null) {
      box.add(defaultValue);
    }
  }
}

class PropertyAccessorTypeAdapter extends TypeAdapter<PropertyAccessorType> {
  @override
  final int typeId = TypeIds.propertyAccessorType;

  @override
  PropertyAccessorType read(BinaryReader reader) {
    final int index = reader.readInt();
    return PropertyAccessorType.values[index];
  }

  @override
  void write(BinaryWriter writer, PropertyAccessorType obj) {
    writer.writeInt(PropertyAccessorType.values.indexOf(obj));
  }
}

class PropertyNamingConventionsTypeAdapter
    extends TypeAdapter<PropertyNamingConventionsType> {
  @override
  final int typeId = TypeIds.propertyNamingConventionsType;

  @override
  PropertyNamingConventionsType read(BinaryReader reader) {
    final int index = reader.readInt();
    return PropertyNamingConventionsType.values[index];
  }

  @override
  void write(BinaryWriter writer, PropertyNamingConventionsType obj) {
    writer.writeInt(PropertyNamingConventionsType.values.indexOf(obj));
  }
}

class PropertyNameSortingTypeAdapter
    extends TypeAdapter<PropertyNameSortingType> {
  @override
  final int typeId = TypeIds.propertyNameSortingType;

  @override
  PropertyNameSortingType read(BinaryReader reader) {
    final int index = reader.readInt();
    return PropertyNameSortingType.values[index];
  }

  @override
  void write(BinaryWriter writer, PropertyNameSortingType obj) {
    writer.writeInt(PropertyNameSortingType.values.indexOf(obj));
  }
}

class LocaleAdapter extends TypeAdapter<Locale> {
  @override
  Locale read(BinaryReader reader) {
    final Map<String, dynamic> map =
        jsonDecode(reader.readString()) as Map<String, dynamic>;
    return Locale.fromSubtags(
      languageCode: map['languageCode']!.toString(),
      scriptCode: map['scriptCode']?.toString(),
      countryCode: map['countryCode']?.toString(),
    );
  }

  @override
  int get typeId => TypeIds.localeType;

  @override
  void write(BinaryWriter writer, Locale obj) {
    writer.writeString(jsonEncode(
      <String, String>{
        'languageCode': obj.languageCode,
        if (obj.scriptCode != null) 'scriptCode': obj.scriptCode!,
        if (obj.countryCode != null) 'countryCode': obj.countryCode!,
      },
    ));
  }
}
