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
    return ConfigSetting()
      ..addMethod = fields[0] as bool
      ..column1Width = fields[1] as int
      ..column2Width = fields[2] as int
      ..enableArrayProtection = fields[3] as bool
      ..enableDataProtection = fields[4] as bool
      ..fileHeaderInfo = fields[5] as String
      ..traverseArrayCount = fields[6] as int
      ..propertyNamingConventionsType =
          fields[7] as PropertyNamingConventionsType
      ..propertyAccessorType = fields[8] as PropertyAccessorType
      ..propertyNameSortingType = fields[9] as PropertyNameSortingType
      ..nullsafety = fields[10] as bool
      ..nullable = fields[11] as bool
      ..locale = fields[12] as Locale
      ..smartNullable = (fields[13] ?? false) as bool;
  }

  @override
  void write(BinaryWriter writer, ConfigSetting obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.smartNullable);
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
