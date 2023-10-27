// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildLogAdapter extends TypeAdapter<ChildLog> {
  @override
  final int typeId = 0;

  @override
  ChildLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChildLog(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      behavioralIssues: (fields[2] as List)?.cast<ChildBehavior>(),
      behavioralIssuesComments: fields[3] as String,
      dayRating: fields[4] as MoodRating,
      dayRatingComments: fields[5] as String,
      familyVisit: fields[6] as bool,
      familyVisitComments: fields[7] as String,
      parentMoodRating: fields[8] as MoodRating,
      parentMoodComments: fields[9] as String,
      childMoodRating: fields[10] as MoodRating,
      childMoodComments: fields[11] as String,
      medicationChange: fields[14] as bool,
      medicationChangeComments: fields[15] as String,
      child: fields[12] as Child,
      notes: (fields[13] as List)?.cast<ChildLogNote>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChildLog obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.behavioralIssues)
      ..writeByte(3)
      ..write(obj.behavioralIssuesComments)
      ..writeByte(4)
      ..write(obj.dayRating)
      ..writeByte(5)
      ..write(obj.dayRatingComments)
      ..writeByte(6)
      ..write(obj.familyVisit)
      ..writeByte(7)
      ..write(obj.familyVisitComments)
      ..writeByte(8)
      ..write(obj.parentMoodRating)
      ..writeByte(9)
      ..write(obj.parentMoodComments)
      ..writeByte(10)
      ..write(obj.childMoodRating)
      ..writeByte(11)
      ..write(obj.childMoodComments)
      ..writeByte(14)
      ..write(obj.medicationChange)
      ..writeByte(15)
      ..write(obj.medicationChangeComments)
      ..writeByte(12)
      ..write(obj.child)
      ..writeByte(13)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildLog _$ChildLogFromJson(Map<String, dynamic> json) {
  return ChildLog(
    id: json['id'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    behavioralIssues: (json['behavioralIssues'] as List)
        ?.map((e) => _$enumDecodeNullable(_$ChildBehaviorEnumMap, e))
        ?.toList(),
    behavioralIssuesComments: json['behavioralIssuesComments'] as String,
    dayRating: _$enumDecodeNullable(_$MoodRatingEnumMap, json['dayRating']),
    dayRatingComments: json['dayRatingComments'] as String,
    familyVisit: json['familyVisit'] as bool,
    familyVisitComments: json['familyVisitComments'] as String,
    parentMoodRating:
        _$enumDecodeNullable(_$MoodRatingEnumMap, json['parentMoodRating']),
    parentMoodComments: json['parentMoodComments'] as String,
    childMoodRating:
        _$enumDecodeNullable(_$MoodRatingEnumMap, json['childMoodRating']),
    childMoodComments: json['childMoodComments'] as String,
    medicationChange: json['medicationChange'] as bool,
    medicationChangeComments: json['medicationChangeComments'] as String,
    child: json['child'] == null
        ? null
        : Child.fromJson(json['child'] as Map<String, dynamic>),
    notes: (json['notes'] as List)
        ?.map((e) =>
            e == null ? null : ChildLogNote.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ChildBehaviorEnumMap = {
  ChildBehavior.bedWetting: 'BEDWETTING',
  ChildBehavior.agression: 'AGRESSION',
  ChildBehavior.food: 'FOODISSUES',
  ChildBehavior.depression: 'DEPRESSION',
  ChildBehavior.anxiety: 'ANXIETY',
  ChildBehavior.schoolIssues: 'SCHOOLISSUES',
  ChildBehavior.other: 'OTHER',
};

const _$MoodRatingEnumMap = {
  MoodRating.hardDay: 'HARDDAY',
  MoodRating.soso: 'SOSO',
  MoodRating.average: 'AVERAGE',
  MoodRating.good: 'GOOD',
  MoodRating.great: 'GREAT',
};
