import 'package:fostershare/core/models/data/resource/resource.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resource_category.g.dart';

@JsonSerializable(createToJson: false)
class ResourceCategory {
  final String id;
  final String name;
  final List<Resource> resources;
  final int resourcesCount;
  final Uri image;
  final Uri alternateImage;
  bool get hasResources =>
      (resourcesCount != null && resourcesCount > 0) ||
      (resources != null && resources.isNotEmpty);

  ResourceCategory({
    this.id,
    this.name,
    this.resources,
    this.resourcesCount,
    this.image,
    this.alternateImage,
  });

  factory ResourceCategory.fromJson(Map<String, dynamic> json) =>
      _$ResourceCategoryFromJson(json);
}
