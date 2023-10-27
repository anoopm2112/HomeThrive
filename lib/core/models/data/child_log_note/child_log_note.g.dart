// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_log_note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildLogNoteAdapter extends TypeAdapter<ChildLogNote> {
  @override
  final int typeId = 4;

  @override
  ChildLogNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChildLogNote(
      id: fields[0] as String,
      createdAt: fields[1] as DateTime,
      text: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChildLogNote obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildLogNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildLogNote _$ChildLogNoteFromJson(Map<String, dynamic> json) {
  return ChildLogNote(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    text: json['text'] as String,
  );
}
