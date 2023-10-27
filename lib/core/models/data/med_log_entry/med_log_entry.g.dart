// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedLogEntry _$MedLogEntryFromJson(Map<String, dynamic> json) {
  return MedLogEntry(
    json['id'] as String,
    json['dateTime'] == null
        ? null
        : DateTime.parse(json['dateTime'] as String),
    json['dateString'] as String,
    json['timeString'] as String,
    json['isFailure'] as bool,
    json['given'] as String,
    _$enumDecodeNullable(_$FailureReasonEnumMap, json['failureReason']),
    json['failureDescription'] as String,
    json['enteredBy'] as String,
    json['medication'] == null
        ? null
        : MedLogMedicationDetail.fromJson(
            json['medication'] as Map<String, dynamic>),
    (json['notes'] as List)
        ?.map((e) =>
            e == null ? null : MedLogNote.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['notesCount'] as int,
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

const _$FailureReasonEnumMap = {
  FailureReason.Refused: 'Refused',
  FailureReason.Missed: 'Missed',
  FailureReason.Error: 'Error',
};
