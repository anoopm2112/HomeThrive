import 'package:json_annotation/json_annotation.dart';

part 'med_log_note.g.dart';

@JsonSerializable(createToJson: false)
class MedLogNote {
  String id;
  String content;
  String enteredBy;

  MedLogNote(this.id, this.content, this.enteredBy);

  factory MedLogNote.fromJson(Map<String, dynamic> json) =>
      _$MedLogNoteFromJson(json);
}
