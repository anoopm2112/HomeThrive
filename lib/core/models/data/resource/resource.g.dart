// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) {
  return Resource(
    id: json['id'] as String,
    title: json['title'] as String,
    summary: json['summary'] as String,
    image: json['image'] == null ? null : Uri.parse(json['image'] as String),
    url: json['url'] == null ? null : Uri.parse(json['url'] as String),
    alternateImageUrl: json['alternateImageUrl'] == null
        ? null
        : Uri.parse(json['alternateImageUrl'] as String),
  );
}
