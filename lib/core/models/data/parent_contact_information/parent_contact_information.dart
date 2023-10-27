import 'package:json_annotation/json_annotation.dart';

part 'parent_contact_information.g.dart';

@JsonSerializable(createToJson: false)
class ParentContactInformation {
  // TODO add checks
  final String id;
  final String firstName;
  final String lastName;
  String get fullName => "$firstName $lastName";
  final String phoneNumber;
  final String email;
  final String occupation;

  const ParentContactInformation({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.occupation,
  });

  factory ParentContactInformation.fromJson(Map<String, dynamic> json) =>
      _$ParentContactInformationFromJson(json);
}
