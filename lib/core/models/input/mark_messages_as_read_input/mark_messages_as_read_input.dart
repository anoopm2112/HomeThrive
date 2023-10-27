import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'mark_messages_as_read_input.g.dart';

@JsonSerializable(createFactory: false)
class MarkMessagesAsReadInput {
  @JsonKey(nullable: false)
  final List<String> ids;

  MarkMessagesAsReadInput({
    @required this.ids,
  }) : assert(
          ids != null && !ids.any((id) => id == null),
        );

  void toJson() => _$MarkMessagesAsReadInputToJson(this);
}
