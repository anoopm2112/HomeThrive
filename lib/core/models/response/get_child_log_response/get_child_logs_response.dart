import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/cursor_page_info/cursor_page_info.dart';
import 'package:fostershare/core/models/response/get_all_logs_response/get_all_logs_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_child_logs_response.g.dart';

@JsonSerializable(createToJson: false)
class GetChildLogsResponse {
  final GetAllLogsResponse items;
  final CursorPageInfo pageInfo;
  bool get hasLogs => items != null;

  const GetChildLogsResponse({
    this.items,
    this.pageInfo,
  });

  factory GetChildLogsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetChildLogsResponseFromJson(json);
}
