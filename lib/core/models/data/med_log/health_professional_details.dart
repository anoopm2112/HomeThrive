import 'package:json_annotation/json_annotation.dart';

part 'health_professional_details.g.dart';

@JsonSerializable(createToJson: false)
class HealthProfessionalDetails {
  String firstName;
  String lastName;

  HealthProfessionalDetails(this.firstName, this.lastName);

  factory HealthProfessionalDetails.fromJson(Map<String, dynamic> json) =>
      _$HealthProfessionalDetailsFromJson(json);
}
