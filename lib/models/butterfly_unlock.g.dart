// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'butterfly_unlock.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ButterflyUnlockAdapter extends TypeAdapter<ButterflyUnlock> {
  @override
  final int typeId = 5;

  @override
  ButterflyUnlock read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ButterflyUnlock(
      id: fields[0] as int?,
      imagePath: fields[1] as String,
      unlockedAt: fields[2] as DateTime,
      goalDurationDays: fields[3] as int,
      isLegendary: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ButterflyUnlock obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.unlockedAt)
      ..writeByte(3)
      ..write(obj.goalDurationDays)
      ..writeByte(4)
      ..write(obj.isLegendary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ButterflyUnlockAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
