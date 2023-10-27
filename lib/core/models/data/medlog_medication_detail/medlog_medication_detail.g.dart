// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medlog_medication_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedLogMedicationDetail _$MedLogMedicationDetailFromJson(
    Map<String, dynamic> json) {
  return MedLogMedicationDetail(
    json['id'] as String,
    json['medicationName'] as String,
    json['reason'] as String,
    json['dosage'] as String,
    json['strength'] as String,
    (json['notes'] as List)
        ?.map((e) =>
            e == null ? null : MedLogNote.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['notesCount'] as int,
    prescriptionDate: json['prescriptionDate'] == null
        ? null
        : DateTime.parse(json['prescriptionDate'] as String),
    prescriptionDateString: json['prescriptionDateString'] as String,
    physicianName: json['physicianName'] as String,
  );
}
