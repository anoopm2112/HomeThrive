import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/event/event.dart';
import 'package:fostershare/core/models/data/cursor_page_info/cursor_page_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_logs_response.g.dart';

@JsonSerializable(createToJson: false)
class GetAllLogsResponse {
  final List<ChildLog> childLog;
  final List<RecreationLog> recreationLog;
  final List<MedLog> medLog;
  final List<Event> events;

  const GetAllLogsResponse(
      {this.childLog, this.recreationLog, this.medLog, this.events});

  factory GetAllLogsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllLogsResponseFromJson(json);
}
