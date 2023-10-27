import 'package:fostershare/core/models/data/parent_contact_information/parent_contact_information.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_secondary_parent_input.g.dart';

@JsonSerializable(createFactory: false)
class CreateSecondaryParentInput {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String occupation;
  final String phoneNumber;

  const CreateSecondaryParentInput(
    this.id, {
    this.firstName,
    this.lastName,
    this.email,
    this.occupation,
    this.phoneNumber,
  });

  factory CreateSecondaryParentInput.fromParentContactInformation(
    ParentContactInformation parentContactInformation,
  ) {
    return CreateSecondaryParentInput(
      parentContactInformation.id,
      firstName: parentContactInformation.firstName,
      lastName: parentContactInformation.lastName,
      email: parentContactInformation.email,
      occupation: parentContactInformation.occupation,
      phoneNumber: parentContactInformation.phoneNumber,
    );
  }

  void toJson() => _$CreateSecondaryParentInputToJson(this);
}
