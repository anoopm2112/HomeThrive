import 'package:json_annotation/json_annotation.dart';

enum SigningStatus {
  @JsonValue("PENDING")
  PENDING,
  @JsonValue("DRAFT")
  DRAFT,
  @JsonValue("SENT")
  SENT,
  @JsonValue("DELIVERED")
  DELIVERED,
  @JsonValue("COMPLETED")
  COMPLETED,
  @JsonValue("DECLINED")
  DECLINED,
  @JsonValue("VOIDED")
  VOIDED,
}
