import 'package:json_annotation/json_annotation.dart';
part 'get_medication_input.g.dart';

@JsonSerializable(createFactory: false)
class GetMedicationInput {
  String medicationId;

  GetMedicationInput(this.medicationId);

  void toJson() => _$GetMedicationInputToJson(this);
}
