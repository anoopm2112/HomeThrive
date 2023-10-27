// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_child_logs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetChildLogsResponse _$GetChildLogsResponseFromJson(Map<String, dynamic> json) {
  return GetChildLogsResponse(
    items: json['items'] == null
        ? null
        : GetAllLogsResponse.fromJson(json['items'] as Map<String, dynamic>),
    pageInfo: json['pageInfo'] == null
        ? null
        : CursorPageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
  );
}
