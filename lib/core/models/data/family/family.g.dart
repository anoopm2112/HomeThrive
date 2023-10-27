// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Family _$FamilyFromJson(Map<String, dynamic> json) {
  return Family(
    id: json['id'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    phoneNumber: json['phoneNumber'] as String,
    email: json['email'] as String,
    occupation: json['occupation'] as String,
    primaryLanguage: json['primaryLanguage'] as String,
    licenseNumber: json['licenseNumber'] as String,
    address: json['address'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    zipCode: json['zipCode'] as String,
    isWeekly: json['isWeekly'] as bool,
    secondaryParents: (json['secondaryParents'] as List)
        ?.map((e) => e == null
            ? null
            : ParentContactInformation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
