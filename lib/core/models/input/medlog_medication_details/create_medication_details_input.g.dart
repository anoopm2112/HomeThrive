// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_medication_details_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$CreateMedicationDetailsInputToJson(
        CreateMedicationDetailsInput instance) =>
    <String, dynamic>{
      'medicationName': instance.medicationName,
      'reason': instance.reason,
      'dosage': instance.dosage,
      'strength': instance.strength,
      'prescriptionDate': instance.prescriptionDate?.toIso8601String(),
      'prescriptionDateString': instance.prescriptionDateString,
      'physicianName': instance.physicianName,
    };
