import 'package:fostershare/core/models/data/cursor_page_info/cursor_page_info.dart';
import 'package:fostershare/core/models/data/med_log_entry/med_log_entry.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_med_log_entries_response.g.dart';

@JsonSerializable(createToJson: false)
class GetMedLogEntriesResponse {
  List<MedLogEntry> items;
  CursorPageInfo pageInfo;

  GetMedLogEntriesResponse(this.items, this.pageInfo);

  factory GetMedLogEntriesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMedLogEntriesResponseFromJson(json);
}
