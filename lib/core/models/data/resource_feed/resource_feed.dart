import 'package:fostershare/core/models/data/resource/resource.dart';
import 'package:fostershare/core/models/data/resource_category/resource_category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'resource_feed.g.dart';

@JsonSerializable(createToJson: false)
class ResourceFeed {
  final List<ResourceCategory> resourceCategories;
  List<ResourceCategory> get nonEmptyResourceCategories => resourceCategories
      ?.where(
        (resourceCategory) => resourceCategory.hasResources,
      )
      ?.toList();
  int get numNonEmptyResourceCategories =>
      nonEmptyResourceCategories?.length ?? 0;

  // TODO put non-null checks
  final List<Resource> localResources;
  bool get hasLocalResources =>
      localResources != null && localResources.length > 0;
  int get localResourcesCount =>
      this.hasLocalResources ? localResources.length : 0;

  final ResourceCategory popularCategory;
  bool get hasPopularCategory =>
      popularCategory != null && popularCategory.hasResources;

  ResourceFeed({
    this.resourceCategories = const [],
    this.localResources = const [],
    this.popularCategory,
  }) : assert(resourceCategories != null);

  factory ResourceFeed.fromJson(Map<String, dynamic> json) =>
      _$ResourceFeedFromJson(json);
}
