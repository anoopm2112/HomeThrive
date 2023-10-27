// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceCategory _$ResourceCategoryFromJson(Map<String, dynamic> json) {
  return ResourceCategory(
    id: json['id'] as String,
    name: json['name'] as String,
    resources: (json['resources'] as List)
        ?.map((e) =>
            e == null ? null : Resource.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    resourcesCount: json['resourcesCount'] as int,
    image: json['image'] == null ? null : Uri.parse(json['image'] as String),
    alternateImage: json['alternateImage'] == null
        ? null
        : Uri.parse(json['alternateImage'] as String),
  );
}
