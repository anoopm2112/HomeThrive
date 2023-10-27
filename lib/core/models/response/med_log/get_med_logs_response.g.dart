// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_med_logs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMedLogsResponse _$GetMedLogsResponseFromJson(Map<String, dynamic> json) {
  return GetMedLogsResponse(
    (json['items'] as List)
        ?.map((e) =>
            e == null ? null : MedLog.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['pageInfo'] == null
        ? null
        : CursorPageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
  );
}
