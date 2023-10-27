import 'package:fostershare/core/models/data/family_image/family_image.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:fostershare/core/models/data/cursor_page_info/cursor_page_info.dart';

part 'get_family_images_response.g.dart';

@JsonSerializable(createToJson: false)
class GetFamilyImagesResponse {
  final List<FamilyImage> items;
  final CursorPageInfo pageInfo;

  const GetFamilyImagesResponse({
    this.items,
    this.pageInfo,
  });

  factory GetFamilyImagesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetFamilyImagesResponseFromJson(json);
}
