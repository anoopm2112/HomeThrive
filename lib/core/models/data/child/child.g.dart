// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildAdapter extends TypeAdapter<Child> {
  @override
  final int typeId = 3;

  @override
  Child read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Child(
      id: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      dateOfBirth: fields[3] as DateTime,
      image: fields[4] as String,
      imageURL: fields[8] as String,
      logsCount: fields[5] as int,
      agentName: fields[6] as String,
      recentLogs: (fields[7] as List)?.cast<ChildLog>(),
      nickName: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Child obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.dateOfBirth)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(8)
      ..write(obj.imageURL)
      ..writeByte(5)
      ..write(obj.logsCount)
      ..writeByte(6)
      ..write(obj.agentName)
      ..writeByte(7)
      ..write(obj.recentLogs)
      ..writeByte(9)
      ..write(obj.nickName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Child _$ChildFromJson(Map<String, dynamic> json) {
  return Child(
    id: json['id'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    dateOfBirth: json['dateOfBirth'] == null
        ? null
        : DateTime.parse(json['dateOfBirth'] as String),
    image: json['image'] as String,
    imageURL: json['imageURL'] as String,
    logsCount: json['logsCount'] as int,
    agentName: json['agentName'] as String,
    recentLogs: (json['recentLogs'] as List)
        ?.map((e) =>
            e == null ? null : ChildLog.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    nickName: json['nickName'] as String,
  );
}
