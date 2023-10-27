import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';

import 'package:json_annotation/json_annotation.dart';

import 'med_log_date_input.dart';
part 'get_med_logs_input.g.dart';

@JsonSerializable(createFactory: false)
class GetMedLogsInput {
  String childId;
  MedLogDateInput fromDate;
  MedLogDateInput toDate;
  CursorPaginationInput pagination;

  GetMedLogsInput(
    this.pagination, {
    this.childId,
    this.fromDate,
    this.toDate,
  });

  void toJson() => _$GetMedLogsInputToJson(this);
}
