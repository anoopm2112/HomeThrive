import 'package:json_annotation/json_annotation.dart';

part 'get_med_log_entry_input.g.dart';

@JsonSerializable(createFactory: false)
class GetMedLogEntryInput {
  String medLogEntryId;

  GetMedLogEntryInput(this.medLogEntryId);

  void toJson() => _$GetMedLogEntryInputToJson(this);
}
