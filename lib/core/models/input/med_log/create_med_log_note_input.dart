import 'package:json_annotation/json_annotation.dart';

part 'create_med_log_note_input.g.dart';

@JsonSerializable(createFactory: false)
class CreateMedLogNoteInput {
  String content;
  String medication;

  CreateMedLogNoteInput(this.content, this.medication);

  void toJson() => _$CreateMedLogNoteInputToJson(this);
}
