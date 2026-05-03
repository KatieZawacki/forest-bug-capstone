// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bug_stage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BugStageAdapter extends TypeAdapter<BugStage> {
  @override
  final int typeId = 3;

  @override
  BugStage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BugStage(
      id: fields[0] as int?,
      stage: fields[1] as String,
      progressPoints: fields[2] as int,
      updatedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BugStage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stage)
      ..writeByte(2)
      ..write(obj.progressPoints)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BugStageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
