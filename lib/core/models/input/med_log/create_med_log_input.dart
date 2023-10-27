import 'package:fostershare/core/models/input/medlog_medication_details/create_medication_details_input.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fostershare/core/models/data/med_log/child_sex_enum.dart';
part 'create_med_log_input.g.dart';

@JsonSerializable(createFactory: false)
class CreateMedLogInput {
  ChildSex sex;
  String allergies;
  int year;
  int month;
  DateTime prescriptionDate;
  String physicianFirstName;
  String physicianLastName;
  String childId;
  List<CreateMedicationDetailsInput> medications;

  CreateMedLogInput(
    this.sex,
    this.year,
    this.month,
    this.childId, {
    this.allergies,
    this.prescriptionDate,
    this.physicianFirstName,
    this.physicianLastName,
    this.medications,
  });

  void toJson() => _$CreateMedLogInputToJson(this);
}
