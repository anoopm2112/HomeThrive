// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_support_services_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSupportServicesResponse _$GetSupportServicesResponseFromJson(
    Map<String, dynamic> json) {
  return GetSupportServicesResponse(
    items: (json['items'] as List)
        ?.map((e) => e == null
            ? null
            : SupportService.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    pageInfo: json['pageInfo'] == null
        ? null
        : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
  );
}
