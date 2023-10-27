import 'package:fostershare/core/models/data/med_log_note/med_log_note.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medlog_medication_detail.g.dart';

@JsonSerializable(createToJson: false)
class MedLogMedicationDetail {
  String id;
  String medicationName;
  String reason;
  String dosage;
  String strength;
  List<MedLogNote> notes;
  int notesCount;
  DateTime prescriptionDate;
  String prescriptionDateString;
  String physicianName;

  MedLogMedicationDetail(this.id, this.medicationName, this.reason, this.dosage,
      this.strength, this.notes, this.notesCount,
      {this.prescriptionDate, this.prescriptionDateString, this.physicianName});

  factory MedLogMedicationDetail.fromJson(Map<String, dynamic> json) =>
      _$MedLogMedicationDetailFromJson(json);
}
