import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/response/get_child_log_response/get_child_logs_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'children_summary.g.dart';

@JsonSerializable(createToJson: false)
class ChildrenSummary {
  final List<Child> children;
  final GetChildLogsResponse logs;
  bool get hasLogs => logs.hasLogs;
  bool get hasChildren => children != null && children.isNotEmpty;

  const ChildrenSummary({this.children, this.logs});

  factory ChildrenSummary.fromJson(Map<String, dynamic> json) =>
      _$ChildrenSummaryFromJson(json);
}
