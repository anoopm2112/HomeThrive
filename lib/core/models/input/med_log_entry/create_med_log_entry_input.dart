import 'package:fostershare/core/models/data/med_log_entry/failure_reason.dart';
import 'package:json_annotation/json_annotation.dart';
part 'create_med_log_entry_input.g.dart';

@JsonSerializable(createFactory: false)
class CreateMedLogEntryInput {
  DateTime entryTime;
  String entryTimeString;
  String entryDateString;
  bool isSuccess;
  String given;
  FailureReason reason;
  String failureDescription;
  String medLogId;
  String medicationId;

  CreateMedLogEntryInput(
    this.entryTime,
    this.entryTimeString,
    this.entryDateString,
    this.isSuccess,
    this.given,
    this.reason,
    this.failureDescription,
    this.medLogId,
    this.medicationId,
  );

  void toJson() => _$CreateMedLogEntryInputToJson(this);
}
