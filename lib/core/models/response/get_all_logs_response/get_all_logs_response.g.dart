// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_logs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllLogsResponse _$GetAllLogsResponseFromJson(Map<String, dynamic> json) {
  return GetAllLogsResponse(
    childLog: (json['childLog'] as List)
        ?.map((e) =>
            e == null ? null : ChildLog.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    recreationLog: (json['recreationLog'] as List)
        ?.map((e) => e == null
            ? null
            : RecreationLog.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    medLog: (json['medLog'] as List)
        ?.map((e) =>
            e == null ? null : MedLog.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    events: (json['events'] as List)
        ?.map(
            (e) => e == null ? null : Event.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
