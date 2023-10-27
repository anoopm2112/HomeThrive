import 'package:json_annotation/json_annotation.dart';
import 'package:fostershare/core/models/data/med_log/signing_status.dart';

part 'update_signing_status_input.g.dart';

@JsonSerializable(createFactory: false)
class UpdateSigningStatusInput {
  String medLogId;
  SigningStatus status;

  UpdateSigningStatusInput(this.medLogId, this.status);

  void toJson() => _$UpdateSigningStatusInputToJson(this);
}
