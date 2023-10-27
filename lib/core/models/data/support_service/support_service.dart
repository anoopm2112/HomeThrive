import 'package:json_annotation/json_annotation.dart';
part 'support_service.g.dart';

@JsonSerializable(createToJson: false)
class SupportService {
  final String id;
  final String name;
  final String description;
  final String email;
  final String phoneNumber;
  final String website;

  SupportService(
      {this.id,
      this.name,
      this.description,
      this.email,
      this.phoneNumber,
      this.website});

  factory SupportService.fromJson(Map<String, dynamic> json) =>
      _$SupportServiceFromJson(json);
}
