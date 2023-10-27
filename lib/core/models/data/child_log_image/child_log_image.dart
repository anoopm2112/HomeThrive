import 'package:json_annotation/json_annotation.dart';

part 'child_log_image.g.dart';

@JsonSerializable(createToJson: false)
class ChildLogImage {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Uri imageURL;
  final String title;

  const ChildLogImage({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.imageURL,
    this.title,
  });

  factory ChildLogImage.fromJson(Map<String, dynamic> json) =>
      _$ChildLogImageFromJson(json);
}
