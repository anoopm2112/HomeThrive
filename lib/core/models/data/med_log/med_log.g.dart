// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'med_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedLog _$MedLogFromJson(Map<String, dynamic> json) {
  return MedLog(
    id: json['id'] as String,
    childSex: _$enumDecodeNullable(_$ChildSexEnumMap, json['childSex']),
    month: json['month'] as int,
    year: json['year'] as int,
    prescriptionDate: json['prescriptionDate'] == null
        ? null
        : DateTime.parse(json['prescriptionDate'] as String),
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    allergies: json['allergies'] as String,
    prescribingHealthProfessional: json['prescribingHealthProfessional'] == null
        ? null
        : HealthProfessionalDetails.fromJson(
            json['prescribingHealthProfessional'] as Map<String, dynamic>),
    signingStatus:
        _$enumDecodeNullable(_$SigningStatusEnumMap, json['signingStatus']),
    isSubmitted: json['isSubmitted'] as bool,
    submittedBy: json['submittedBy'] as String,
    documentUrl: json['documentUrl'] as String,
    medications: (json['medications'] as List)
        ?.map((e) => e == null
            ? null
            : MedLogMedicationDetail.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    entries: (json['entries'] as List)
        ?.map((e) =>
            e == null ? null : MedLogEntry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    notes: (json['notes'] as List)
        ?.map((e) =>
            e == null ? null : MedLogNote.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    child: json['child'] == null
        ? null
        : Child.fromJson(json['child'] as Map<String, dynamic>),
    family: json['family'] == null
        ? null
        : Family.fromJson(json['family'] as Map<String, dynamic>),
    canSign: json['canSign'] as bool,
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

const _$ChildSexEnumMap = {
  ChildSex.Male: 'Male',
  ChildSex.Female: 'Female',
  ChildSex.Other: 'Other',
};

const _$SigningStatusEnumMap = {
  SigningStatus.PENDING: 'PENDING',
  SigningStatus.DRAFT: 'DRAFT',
  SigningStatus.SENT: 'SENT',
  SigningStatus.DELIVERED: 'DELIVERED',
  SigningStatus.COMPLETED: 'COMPLETED',
  SigningStatus.DECLINED: 'DECLINED',
  SigningStatus.VOIDED: 'VOIDED',
};
