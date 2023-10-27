import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'invitiation_input.g.dart';

@JsonSerializable(createFactory: false)
class InvitiationInput {
  final String email;

  const InvitiationInput({
    @required this.email,
  }) : assert(email != null);

  void toJson() => _$InvitiationInputToJson(this);
}
