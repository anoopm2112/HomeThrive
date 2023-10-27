import 'package:json_annotation/json_annotation.dart';

part 'create_medication_details_input.g.dart';

@JsonSerializable(createFactory: false)
class CreateMedicationDetailsInput {
  String medicationName;
  String reason;
  String dosage;
  String strength;
  DateTime prescriptionDate;
  String prescriptionDateString;
  String physicianName;

  CreateMedicationDetailsInput(
    this.medicationName,
    this.reason,
    this.dosage,
    this.strength, {
    this.prescriptionDate,
    this.prescriptionDateString,
    this.physicianName,
  });

  void toJson() => _$CreateMedicationDetailsInputToJson(this);
}
