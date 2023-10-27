// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'children_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildrenSummary _$ChildrenSummaryFromJson(Map<String, dynamic> json) {
  return ChildrenSummary(
    children: (json['children'] as List)
        ?.map(
            (e) => e == null ? null : Child.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    logs: json['logs'] == null
        ? null
        : GetChildLogsResponse.fromJson(json['logs'] as Map<String, dynamic>),
  );
}
