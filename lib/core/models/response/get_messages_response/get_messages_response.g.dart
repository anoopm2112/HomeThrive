// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_messages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMessagesResponse _$GetMessagesResponseFromJson(Map<String, dynamic> json) {
  return GetMessagesResponse(
    items: (json['items'] as List)
        ?.map((e) =>
            e == null ? null : Message.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    pageInfo: json['pageInfo'] == null
        ? null
        : CursorPageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
  );
}
