// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_family_images_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetFamilyImagesResponse _$GetFamilyImagesResponseFromJson(
    Map<String, dynamic> json) {
  return GetFamilyImagesResponse(
    items: (json['items'] as List)
        ?.map((e) =>
            e == null ? null : FamilyImage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    pageInfo: json['pageInfo'] == null
        ? null
        : CursorPageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
  );
}
