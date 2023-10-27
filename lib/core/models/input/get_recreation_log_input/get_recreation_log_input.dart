import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_recreation_log_input.g.dart';

@JsonSerializable(createFactory: false)
class GetRecreationLogInput {
  final String recreationLogId;

  const GetRecreationLogInput({
    @required this.recreationLogId,
  }) : assert(recreationLogId != null);

  void toJson() => _$GetRecreationLogInputToJson(this);
}
