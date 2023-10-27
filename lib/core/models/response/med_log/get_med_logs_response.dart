import 'package:fostershare/core/models/data/cursor_page_info/cursor_page_info.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:json_annotation/json_annotation.dart';
part 'get_med_logs_response.g.dart';

@JsonSerializable(createToJson: false)
class GetMedLogsResponse {
  List<MedLog> items;
  CursorPageInfo pageInfo;

  GetMedLogsResponse(this.items, this.pageInfo);

  factory GetMedLogsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMedLogsResponseFromJson(json);
}
