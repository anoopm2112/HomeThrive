import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_child_logs_input.g.dart';

@JsonSerializable(createFactory: false)
class GetChildLogInput {
  final String id;

  const GetChildLogInput({
    @required this.id,
  }) : assert(id != null);

  void toJson() => _$GetChildLogInputToJson(this);
}
