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
      ..addMethod = fields[0] == null ? true : fields[0] as bool
      ..column1Width = fields[1] == null ? 2 : fields[1] as int
      ..column2Width = fields[2] == null ? 3 : fields[2] as int
      ..enableArrayProtection = fields[3] == null ? false : fields[3] as bool
      ..enableDataProtection = fields[4] == null ? false : fields[4] as bool
      ..fileHeaderInfo = fields[5] == null ? '' : fields[5] as String
      ..traverseArrayCount = fields[6] == null ? 1 : fields[6] as int
      ..propertyNamingConventionsType = fields[7] == null
          ? PropertyNamingConventionsType.camelCase
          : fields[7] as PropertyNamingConventionsType
      ..propertyNameSortingType = fields[9] == null
          ? PropertyNameSortingType.none
          : fields[9] as PropertyNameSortingType
      ..addCopyMethod = fields[14] == null ? false : fields[14] as bool
      ..propertyAccessorType = fields[8] == null
          ? PropertyAccessorType.none
          : fields[8] as PropertyAccessorType
      ..nullsafety = fields[10] == null ? false : fields[10] as bool
      ..nullable = fields[11] == null ? true : fields[11] as bool
      ..locale = fields[12] == null
          ? const Locale.fromSubtags(languageCode: 'en')
          : fields[12] as Locale
      ..smartNullable = fields[13] == null ? false : fields[13] as bool;
  }

  @override
  void write(BinaryWriter writer, ConfigSetting obj) {
    writer
      ..writeByte(15)
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
      ..writeByte(9)
      ..write(obj.propertyNameSortingType)
      ..writeByte(14)
      ..write(obj.addCopyMethod)
      ..writeByte(8)
      ..write(obj.propertyAccessorType)
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
