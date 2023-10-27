// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_log_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildLogImage _$ChildLogImageFromJson(Map<String, dynamic> json) {
  return ChildLogImage(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
    imageURL:
        json['imageURL'] == null ? null : Uri.parse(json['imageURL'] as String),
    title: json['title'] as String,
  );
}
