import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

  @HiveField(
    0,
    defaultValue: true,
  )
  bool addMethod = true;
  @HiveField(
    1,
    defaultValue: 2,
  )
  int column1Width = 2;
  @HiveField(
    2,
    defaultValue: 3,
  )
  int column2Width = 3;
  @HiveField(
    3,
    defaultValue: false,
  )
  bool enableArrayProtection = false;
  @HiveField(
    4,
    defaultValue: false,
  )
  bool enableDataProtection = false;
  @HiveField(
    5,
    defaultValue: '',
  )
  String fileHeaderInfo = '';
  @HiveField(
    6,
    defaultValue: 1,
  )
  int traverseArrayCount = 1;
  @HiveField(
    7,
    defaultValue: PropertyNamingConventionsType.camelCase,
  )
  PropertyNamingConventionsType propertyNamingConventionsType =
      PropertyNamingConventionsType.camelCase;

  PropertyAccessorType _propertyAccessorType = PropertyAccessorType.none;
  @HiveField(
    8,
    defaultValue: PropertyAccessorType.none,
  )
  PropertyAccessorType get propertyAccessorType => _propertyAccessorType;
  @HiveField(
    8,
    defaultValue: PropertyAccessorType.none,
  )
  set propertyAccessorType(PropertyAccessorType value) {
    if (_propertyAccessorType != value) {
      _propertyAccessorType = value;
      notifyListeners();
    }
  }

  @HiveField(
    9,
    defaultValue: PropertyNameSortingType.none,
  )
  PropertyNameSortingType propertyNameSortingType =
      PropertyNameSortingType.none;

  bool _nullsafety = false;
  @HiveField(
    10,
    defaultValue: false,
  )
  bool get nullsafety => _nullsafety;
  @HiveField(
    10,
    defaultValue: false,
  )
  set nullsafety(bool value) {
    if (_nullsafety != value) {
      _nullsafety = value;
      notifyListeners();
    }
  }

  bool _nullable = true;
  @HiveField(
    11,
    defaultValue: true,
  )
  bool get nullable => _nullable;
  @HiveField(
    11,
    defaultValue: true,
  )
  set nullable(bool value) {
    if (_nullable != value) {
      _nullable = value;
      notifyListeners();
    }
  }

  Locale _locale = const Locale.fromSubtags(languageCode: 'en');
  @HiveField(
    12,
    defaultValue: Locale.fromSubtags(languageCode: 'en'),
  )
  Locale get locale => _locale;
  @HiveField(
    12,
    defaultValue: Locale.fromSubtags(languageCode: 'en'),
  )
  set locale(Locale value) {
    // fix hive error
    // we change zh_Hans to zh
    if (value.languageCode == 'zh' && value.scriptCode == 'Hans') {
      value = const Locale.fromSubtags(
        languageCode: 'zh',
      );
    }
    if (_locale != value) {
      _locale = value;
      notifyListeners();
    }
  }

  bool _smartNullable = false;
  @HiveField(
    13,
    defaultValue: false,
  )
  bool get smartNullable => _smartNullable;
  @HiveField(
    13,
    defaultValue: false,
  )
  set smartNullable(bool value) {
    if (_smartNullable != value) {
      _smartNullable = value;
      notifyListeners();
    }
  }

  @HiveField(
    14,
    defaultValue: false,
  )
  bool addCopyMethod = false;
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
