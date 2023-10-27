import 'package:json_annotation/json_annotation.dart';
part 'get_med_log_input.g.dart';

@JsonSerializable(createFactory: false)
class GetMedLogInput {
  String medLogId;

  GetMedLogInput(this.medLogId);

  void toJson() => _$GetMedLogInputToJson(this);
}
