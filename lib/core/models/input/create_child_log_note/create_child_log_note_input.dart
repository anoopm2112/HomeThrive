import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'create_child_log_note_input.g.dart';

@JsonSerializable(createFactory: false)
class CreateChildLogNoteInput {
  final String childLogId;
  final String text;

  const CreateChildLogNoteInput({
    @required this.childLogId,
    @required this.text,
  })  : assert(childLogId != null),
        assert(text != null);

  void toJson() => _$CreateChildLogNoteInputToJson(this);
}
