import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_children_logs_input.g.dart';

@JsonSerializable(createFactory: false)
class GetChildrenLogsInput {
  final DateTime fromDate;
  final DateTime toDate;
  final CursorPaginationInput pagination;

  const GetChildrenLogsInput({
    this.fromDate,
    this.toDate,
    @required this.pagination,
  }) : assert(pagination != null);

  void toJson() => _$GetChildrenLogsInputToJson(this);
}
