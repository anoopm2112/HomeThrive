import 'package:json_annotation/json_annotation.dart';

part 'create_med_log_entry_note_input.g.dart';

@JsonSerializable(createFactory: false)
class CreateMedLogEntryNoteInput {
  String content;

  CreateMedLogEntryNoteInput(this.content);

  void toJson() => _$CreateMedLogEntryNoteInputToJson(this);
}
