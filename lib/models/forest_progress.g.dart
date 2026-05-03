// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forest_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForestProgressAdapter extends TypeAdapter<ForestProgress> {
  @override
  final int typeId = 4;

  @override
  ForestProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForestProgress(
      id: fields[0] as int?,
      totalTrees: fields[1] as int,
      bloomedTrees: fields[2] as int,
      lastResetDate: fields[3] as DateTime,
      bloomCycleLength: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ForestProgress obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.totalTrees)
      ..writeByte(2)
      ..write(obj.bloomedTrees)
      ..writeByte(3)
      ..write(obj.lastResetDate)
      ..writeByte(4)
      ..write(obj.bloomCycleLength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForestProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
