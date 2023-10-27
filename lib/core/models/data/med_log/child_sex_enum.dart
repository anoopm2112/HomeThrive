import 'package:json_annotation/json_annotation.dart';

enum ChildSex {
  @JsonValue("Male")
  Male,
  @JsonValue("Female")
  Female,
  @JsonValue("Other")
  Other
}
