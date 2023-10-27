import 'package:json_annotation/json_annotation.dart';

enum FailureReason {
  @JsonValue("Refused")
  Refused,
  @JsonValue("Missed")
  Missed,
  @JsonValue("Error")
  Error
}
