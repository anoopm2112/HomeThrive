import 'package:fostershare/core/models/input/create_secondary_parent_input/create_secondary_parent_input.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_profile_input.g.dart';

@JsonSerializable(createFactory: false)
class UpdateProfileInput {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String primaryLanguage;
  final String occupation;
  final String licenseNumber;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  //final bool isWeekly;
  final List<CreateSecondaryParentInput> secondaryParents;

  const UpdateProfileInput({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.primaryLanguage,
    this.occupation,
    this.licenseNumber,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    //this.isWeekly,
    this.secondaryParents,
  });

  void toJson() => _$UpdateProfileInputToJson(this);
}
