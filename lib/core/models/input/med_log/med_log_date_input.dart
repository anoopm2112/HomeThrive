import 'package:json_annotation/json_annotation.dart';

part 'med_log_date_input.g.dart';

@JsonSerializable(createFactory: false)
class MedLogDateInput {
  int month;
  int year;

  MedLogDateInput(this.year, this.month);

  void toJson() => _$MedLogDateInputToJson(this);
}
