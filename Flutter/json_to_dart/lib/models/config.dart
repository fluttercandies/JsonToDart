import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:json_to_dart/utils/enums.dart';

part 'config.g.dart';

/// flutter packages pub run build_runner build --delete-conflicting-outputs
@HiveType(typeId: TypeIds.appSetting)
class ConfigSetting extends Setting<ConfigSetting> {
  factory ConfigSetting() => _appSetting;
  ConfigSetting._();
  static final ConfigSetting _appSetting = ConfigSetting._();
  @HiveField(0)
  RxBool addMethod = true.obs;
  @HiveField(1)
  int column1Width = 2;

  @HiveField(2)
  int column2Width = 3;

  @HiveField(3)
  RxBool enableArrayProtection = false.obs;

  @HiveField(4)
  RxBool enableDataProtection = false.obs;

  @HiveField(5)
  String fileHeaderInfo = '';

  @HiveField(6)
  RxInt traverseArrayCount = 1.obs;
  @HiveField(7)
  Rx<PropertyNamingConventionsType> propertyNamingConventionsType =
      PropertyNamingConventionsType.camelCase.obs;
  @HiveField(8)
  Rx<PropertyAccessorType> propertyAccessorType = PropertyAccessorType.none.obs;
  @HiveField(9)
  Rx<PropertyNameSortingType> propertyNameSortingType =
      PropertyNameSortingType.none.obs;

  @HiveField(10, defaultValue: false)
  bool nullsafety = false;
  RxBool nullsafetyObs = false.obs;

  @HiveField(11, defaultValue: true)
  bool nullable = true;
  RxBool nullableObs = true.obs;

  @HiveField(12)
  Rx<Locale> locale = const Locale.fromSubtags(languageCode: 'en').obs;

  @HiveField(13, defaultValue: false)
  bool smartNullable = false;
  RxBool smartNullableObs = false.obs;
  @HiveField(14)
  RxBool addCopyMethod = false.obs;

  @HiveField(15)
  RxBool automaticCheck = true.obs;

  @override
  Future<void> init({
    TypeAdapter<ConfigSetting>? adapter,
    ConfigSetting? defaultValue,
  }) async {
    Hive.registerAdapter(RxTypeAdapter<PropertyAccessorType>(5));
    Hive.registerAdapter(RxTypeAdapter<PropertyNamingConventionsType>(6));
    Hive.registerAdapter(RxTypeAdapter<PropertyNameSortingType>(7));
    Hive.registerAdapter(RxTypeAdapter<Locale>(8));
    Hive.registerAdapter(RxTypeAdapter<int>(9));
    Hive.registerAdapter(RxTypeAdapter<String>(10));
    Hive.registerAdapter(RxTypeAdapter<bool>(11));
    await super.init(adapter: ConfigSettingAdapter(), defaultValue: this);
  }
}

class RxTypeAdapter<T> extends TypeAdapter<Rx<T>> {
  RxTypeAdapter(this.typeId);
  @override
  final int typeId;
  @override
  Rx<T> read(BinaryReader reader) {
    if (0 is T) {
      return reader.readInt().obs as Rx<T>;
    } else if (true is T) {
      return reader.readBool().obs as Rx<T>;
    } else if ('' is T) {
      return reader.readString().obs as Rx<T>;
    } else if (PropertyAccessorType.none is T) {
      return PropertyAccessorType.values[reader.readInt()].obs as Rx<T>;
    } else if (PropertyNamingConventionsType.none is T) {
      return PropertyNamingConventionsType.values[reader.readInt()].obs
          as Rx<T>;
    } else if (PropertyNameSortingType.none is T) {
      return PropertyNameSortingType.values[reader.readInt()].obs as Rx<T>;
    } else if (T.toString() == 'Locale') {
      final Map<String, dynamic> map =
          jsonDecode(reader.readString()) as Map<String, dynamic>;
      return Locale.fromSubtags(
        languageCode: map['languageCode']!.toString(),
        scriptCode: map['scriptCode']?.toString(),
        countryCode: map['countryCode']?.toString(),
      ).obs as Rx<T>;
    } else {
      throw Exception('not support');
    }
  }

  @override
  void write(BinaryWriter writer, Rx<T> obj) {
    if (obj.value is PropertyAccessorType) {
      writer.writeInt(PropertyAccessorType.values
          .indexOf(obj.value as PropertyAccessorType));
    } else if (obj.value is PropertyNamingConventionsType) {
      writer.writeInt(PropertyNamingConventionsType.values
          .indexOf(obj.value as PropertyNamingConventionsType));
    } else if (obj.value is PropertyNameSortingType) {
      writer.writeInt(PropertyNameSortingType.values
          .indexOf(obj.value as PropertyNameSortingType));
    } else if (obj.value is Locale) {
      final Locale locale = obj.value as Locale;
      writer.writeString(jsonEncode(
        <String, String>{
          'languageCode': locale.languageCode,
          if (locale.scriptCode != null) 'scriptCode': locale.scriptCode!,
          if (locale.countryCode != null) 'countryCode': locale.countryCode!,
        },
      ));
    } else if (obj.value is bool) {
      writer.writeBool(obj.value as bool);
    } else if (obj.value is int) {
      writer.writeInt(obj.value as int);
    } else if (obj.value is String) {
      writer.writeString(obj.value as String);
    } else {
      throw Exception('not support');
    }
  }
}

class Setting<T extends HiveObject> extends HiveObject {
  @mustCallSuper
  Future<void> init({TypeAdapter<T>? adapter, T? defaultValue}) async {
    Hive.registerAdapter<T>(adapter!);
    final String tType = 'JsonToDart' + runtimeType.toString();
    final Box<T> box = await Hive.openBox<T>(tType);
    if ((box.isEmpty || box.getAt(0) == null) && defaultValue != null) {
      box.add(defaultValue);
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
