import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

@JsonSerializable(createToJson: false)
class Resource {
  final String id;
  final String title;
  final String summary;
  final Uri image;
  final Uri url;
  final Uri alternateImageUrl;

  const Resource(
      {this.id,
      this.title,
      this.summary,
      this.image,
      this.url,
      this.alternateImageUrl});

  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);
}
