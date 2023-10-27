import 'package:json_annotation/json_annotation.dart';
part 'generate_signing_request_input.g.dart';

@JsonSerializable(createFactory: false)
class GenerateSigningRequestInput {
  String medLogId;

  GenerateSigningRequestInput(this.medLogId);

  void toJson() => _$GenerateSigningRequestInputToJson(this);
}
