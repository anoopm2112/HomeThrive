import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/data/cursor_page_info/cursor_page_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_recreation_logs_response.g.dart';

@JsonSerializable(createToJson: false)
class GetRecreationLogsResponse {
  final List<RecreationLog> items;
  final CursorPageInfo pageInfo;
  bool get hasLogs => items != null && items.isNotEmpty;

  const GetRecreationLogsResponse({
    this.items,
    this.pageInfo,
  });

  factory GetRecreationLogsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetRecreationLogsResponseFromJson(json);
}
