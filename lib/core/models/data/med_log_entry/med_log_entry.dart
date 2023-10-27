import 'package:fostershare/core/models/data/med_log_note/med_log_note.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:json_annotation/json_annotation.dart';

import 'failure_reason.dart';
part 'med_log_entry.g.dart';

@JsonSerializable(createToJson: false)
class MedLogEntry {
  String id;
  DateTime dateTime;
  String dateString;
  String timeString;
  bool isFailure;
  String given;
  FailureReason failureReason;
  String failureDescription;
  String enteredBy;
  MedLogMedicationDetail medication;
  List<MedLogNote> notes;
  int notesCount;

  MedLogEntry(
    this.id,
    this.dateTime,
    this.dateString,
    this.timeString,
    this.isFailure,
    this.given,
    this.failureReason,
    this.failureDescription,
    this.enteredBy,
    this.medication,
    this.notes,
    this.notesCount,
  );

  factory MedLogEntry.fromJson(Map<String, dynamic> json) =>
      _$MedLogEntryFromJson(json);
}
