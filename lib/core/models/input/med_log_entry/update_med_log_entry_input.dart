import 'package:json_annotation/json_annotation.dart';

import 'create_med_log_entry_note_input.dart';

part 'update_med_log_entry_input.g.dart';

@JsonSerializable(createFactory: false)
class UpdateMedLogEntryInput {
  String entryId;
  List<CreateMedLogEntryNoteInput> notes;

  UpdateMedLogEntryInput(this.entryId, this.notes);

  void toJson() => _$UpdateMedLogEntryInputToJson(this);
}
