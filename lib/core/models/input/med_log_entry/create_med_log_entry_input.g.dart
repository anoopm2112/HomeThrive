// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_med_log_entry_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$CreateMedLogEntryInputToJson(
        CreateMedLogEntryInput instance) =>
    <String, dynamic>{
      'entryTime': instance.entryTime?.toIso8601String(),
      'entryTimeString': instance.entryTimeString,
      'entryDateString': instance.entryDateString,
      'isSuccess': instance.isSuccess,
      'given': instance.given,
      'reason': _$FailureReasonEnumMap[instance.reason],
      'failureDescription': instance.failureDescription,
      'medLogId': instance.medLogId,
      'medicationId': instance.medicationId,
    };

const _$FailureReasonEnumMap = {
  FailureReason.Refused: 'Refused',
  FailureReason.Missed: 'Missed',
  FailureReason.Error: 'Error',
};
