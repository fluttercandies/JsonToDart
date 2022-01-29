// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigSettingAdapter extends TypeAdapter<ConfigSetting> {
  @override
  final int typeId = 0;

  @override
  ConfigSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    final result = ConfigSetting();
    if (fields[0] != null) {
      result.addMethod = fields[0] as RxBool;
    }
    if (fields[1] != null) {
      result.column1Width = fields[1] as int;
    }
    if (fields[2] != null) {
      result.column2Width = fields[2] as int;
    }
    if (fields[3] != null) {
      result.enableArrayProtection = fields[3] as RxBool;
    }
    if (fields[4] != null) {
      result.enableDataProtection = fields[4] as RxBool;
    }
    if (fields[5] != null) {
      result.fileHeaderInfo = fields[5] as String;
    }
    if (fields[6] != null) {
      result.traverseArrayCount = fields[6] as RxInt;
    }
    if (fields[7] != null) {
      result.propertyNamingConventionsType =
          fields[7] as Rx<PropertyNamingConventionsType>;
    }
    if (fields[8] != null) {
      result.propertyAccessorType = fields[8] as Rx<PropertyAccessorType>;
    }
    if (fields[9] != null) {
      result.propertyNameSortingType = fields[9] as Rx<PropertyNameSortingType>;
    }
    if ((fields[10] ?? false) != null) {
      result.nullsafety = fields[10] ?? false;
    }

    if ((fields[11] ?? true) != null) {
      result.nullable = fields[11] ?? true;
    }

    if (fields[12] != null) {
      result.locale = fields[12] as Rx<Locale>;
    }
    if ((fields[13] ?? false) != null) {
      result.smartNullable = fields[13] ?? false;
    }

    if (fields[14] != null) {
      result.addCopyMethod = fields[14] as RxBool;
    }
    if (fields[15] != null) {
      result.automaticCheck = fields[15] as RxBool;
    }
    return result;
  }

  @override
  void write(BinaryWriter writer, ConfigSetting obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.addMethod)
      ..writeByte(1)
      ..write(obj.column1Width)
      ..writeByte(2)
      ..write(obj.column2Width)
      ..writeByte(3)
      ..write(obj.enableArrayProtection)
      ..writeByte(4)
      ..write(obj.enableDataProtection)
      ..writeByte(5)
      ..write(obj.fileHeaderInfo)
      ..writeByte(6)
      ..write(obj.traverseArrayCount)
      ..writeByte(7)
      ..write(obj.propertyNamingConventionsType)
      ..writeByte(8)
      ..write(obj.propertyAccessorType)
      ..writeByte(9)
      ..write(obj.propertyNameSortingType)
      ..writeByte(10)
      ..write(obj.nullsafety)
      ..writeByte(11)
      ..write(obj.nullable)
      ..writeByte(12)
      ..write(obj.locale)
      ..writeByte(13)
      ..write(obj.smartNullable)
      ..writeByte(14)
      ..write(obj.addCopyMethod)
      ..writeByte(15)
      ..write(obj.automaticCheck);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
