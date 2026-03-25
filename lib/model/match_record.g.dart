// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchRecordAdapter extends TypeAdapter<MatchRecord> {
  @override
  final int typeId = 0;

  @override
  MatchRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MatchRecord(
      eventName: fields[0] as String,
      date: fields[1] as DateTime,
      format: fields[2] as String,
      usedLrig: fields[3] as String,
      round: fields[4] as int,
      opponentLrig: fields[5] as String,
      firstSecond: fields[6] as String,
      result: fields[7] as String,
      selfLb: fields[8] as int,
      opponentLb: fields[9] as int,
      memo: fields[10] as String,
      imagePath: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MatchRecord obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.format)
      ..writeByte(3)
      ..write(obj.usedLrig)
      ..writeByte(4)
      ..write(obj.round)
      ..writeByte(5)
      ..write(obj.opponentLrig)
      ..writeByte(6)
      ..write(obj.firstSecond)
      ..writeByte(7)
      ..write(obj.result)
      ..writeByte(8)
      ..write(obj.selfLb)
      ..writeByte(9)
      ..write(obj.opponentLb)
      ..writeByte(10)
      ..write(obj.memo)
      ..writeByte(11)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
