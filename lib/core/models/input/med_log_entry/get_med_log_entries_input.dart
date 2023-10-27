import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:json_annotation/json_annotation.dart';
part 'get_med_log_entries_input.g.dart';

@JsonSerializable(createFactory: false)
class GetMedLogEntriesInput {
  String medLogId;
  bool isSuccess;
  String medicationId;
  CursorPaginationInput pagination;

  GetMedLogEntriesInput(
    this.medLogId,
    this.pagination, {
    this.isSuccess,
    this.medicationId,
  });

  void toJson() => _$GetMedLogEntriesInputToJson(this);
}
