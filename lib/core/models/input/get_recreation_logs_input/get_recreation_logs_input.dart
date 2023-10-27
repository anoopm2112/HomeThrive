import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_recreation_logs_input.g.dart';

@JsonSerializable(createFactory: false)
class GetRecreationLogsInput {
  final DateTime fromDate;
  final DateTime toDate;
  final CursorPaginationInput pagination;

  const GetRecreationLogsInput({
    this.fromDate,
    this.toDate,
    @required this.pagination,
  }) : assert(pagination != null);

  void toJson() => _$GetRecreationLogsInputToJson(this);
}
