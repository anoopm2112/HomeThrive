import 'package:fostershare/core/models/data/parent_contact_information/parent_contact_information.dart';
import 'package:json_annotation/json_annotation.dart';

part 'family.g.dart';

@JsonSerializable(createToJson: false)
class Family {
  final String id;
  final String firstName;
  final String lastName;
  String get fullName => "$firstName $lastName";
  final String phoneNumber;
  final String email;
  final String occupation;
  final String primaryLanguage;
  final String licenseNumber;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final bool isWeekly;
  final List<ParentContactInformation> secondaryParents;
  bool get hasSecondaryParents =>
      this.secondaryParents != null && this.secondaryParents.isNotEmpty;

  const Family({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.occupation,
    this.primaryLanguage,
    this.licenseNumber,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.isWeekly,
    this.secondaryParents = const [],
  });

  factory Family.fromJson(Map<String, dynamic> json) => _$FamilyFromJson(json);
}
