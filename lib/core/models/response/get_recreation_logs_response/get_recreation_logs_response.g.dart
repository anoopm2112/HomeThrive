// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_recreation_logs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetRecreationLogsResponse _$GetRecreationLogsResponseFromJson(
    Map<String, dynamic> json) {
  return GetRecreationLogsResponse(
    items: (json['items'] as List)
        ?.map((e) => e == null
            ? null
            : RecreationLog.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    pageInfo: json['pageInfo'] == null
        ? null
        : CursorPageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
  );
}
