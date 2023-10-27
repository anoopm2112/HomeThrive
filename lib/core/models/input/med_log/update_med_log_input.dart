import 'package:fostershare/core/models/input/medlog_medication_details/create_medication_details_input.dart';
import 'package:json_annotation/json_annotation.dart';

import 'create_med_log_note_input.dart';

part 'update_med_log_input.g.dart';

@JsonSerializable(createFactory: false)
class UpdateMedLogInput {
  String medLogId;
  List<CreateMedicationDetailsInput> medications;
  List<CreateMedLogNoteInput> notes;

  UpdateMedLogInput(this.medLogId, {this.medications, this.notes});

  void toJson() => _$UpdateMedLogInputToJson(this);
}
