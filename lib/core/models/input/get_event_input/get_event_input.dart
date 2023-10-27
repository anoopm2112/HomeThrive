import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_event_input.g.dart';

@JsonSerializable(createFactory: false)
class GetEventInput {
  @JsonKey(nullable: false)
  final String id;

  const GetEventInput({
    @required this.id,
  }) : assert(id != null);

  void toJson() => _$GetEventInputToJson(this);
}
