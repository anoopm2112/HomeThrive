// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_med_log_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$CreateMedLogInputToJson(CreateMedLogInput instance) =>
    <String, dynamic>{
      'sex': _$ChildSexEnumMap[instance.sex],
      'allergies': instance.allergies,
      'year': instance.year,
      'month': instance.month,
      'prescriptionDate': instance.prescriptionDate?.toIso8601String(),
      'physicianFirstName': instance.physicianFirstName,
      'physicianLastName': instance.physicianLastName,
      'childId': instance.childId,
      'medications': instance.medications,
    };

const _$ChildSexEnumMap = {
  ChildSex.Male: 'Male',
  ChildSex.Female: 'Female',
  ChildSex.Other: 'Other',
};
