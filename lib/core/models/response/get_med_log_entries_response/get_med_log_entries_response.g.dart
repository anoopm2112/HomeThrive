// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_med_log_entries_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMedLogEntriesResponse _$GetMedLogEntriesResponseFromJson(
    Map<String, dynamic> json) {
  return GetMedLogEntriesResponse(
    (json['items'] as List)
        ?.map((e) =>
            e == null ? null : MedLogEntry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['pageInfo'] == null
        ? null
        : CursorPageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
  );
}
