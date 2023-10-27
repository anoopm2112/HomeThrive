// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceFeed _$ResourceFeedFromJson(Map<String, dynamic> json) {
  return ResourceFeed(
    resourceCategories: (json['resourceCategories'] as List)
        ?.map((e) => e == null
            ? null
            : ResourceCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    localResources: (json['localResources'] as List)
        ?.map((e) =>
            e == null ? null : Resource.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    popularCategory: json['popularCategory'] == null
        ? null
        : ResourceCategory.fromJson(
            json['popularCategory'] as Map<String, dynamic>),
  );
}
