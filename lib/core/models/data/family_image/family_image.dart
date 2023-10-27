import 'package:fostershare/core/models/data/family/family.dart';
import 'package:json_annotation/json_annotation.dart';
part 'family_image.g.dart';

@JsonSerializable(createToJson: false)
class FamilyImage {
  final String id;
  final String url;
  final String name;
  final String file;

  FamilyImage({this.id, this.url, this.name, this.file});

  factory FamilyImage.fromJson(Map<String, dynamic> json) =>
      _$FamilyImageFromJson(json);
}
