import 'package:fostershare/core/models/data/med_log_note/med_log_note.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/family/family.dart';
import 'package:fostershare/core/models/data/med_log_entry/med_log_entry.dart';

import 'child_sex_enum.dart';
import 'health_professional_details.dart';
import 'signing_status.dart';

part 'med_log.g.dart';

@JsonSerializable(createToJson: false)
class MedLog {
  String id;
  ChildSex childSex;
  int month;
  int year;
  DateTime prescriptionDate;
  DateTime createdAt;
  String allergies;
  HealthProfessionalDetails prescribingHealthProfessional;
  SigningStatus signingStatus;
  bool isSubmitted;
  String submittedBy;
  String documentUrl;
  List<MedLogMedicationDetail> medications;
  List<MedLogNote> notes;
  List<MedLogEntry> entries;
  Child child;
  Family family;
  bool canSign;

  MedLog({
    this.id,
    this.childSex,
    this.month,
    this.year,
    this.prescriptionDate,
    this.createdAt,
    this.allergies,
    this.prescribingHealthProfessional,
    this.signingStatus,
    this.isSubmitted,
    this.submittedBy,
    this.documentUrl,
    this.medications,
    this.entries,
    this.notes,
    this.child,
    this.family,
    this.canSign,
  });

  factory MedLog.fromJson(Map<String, dynamic> json) => _$MedLogFromJson(json);
}
