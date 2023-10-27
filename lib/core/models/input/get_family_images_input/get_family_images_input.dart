import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_family_images_input.g.dart';

@JsonSerializable(createFactory: false)
class GetFamilyImagesInput {
  @JsonKey(nullable: false)
  final CursorPaginationInput pagination;

  const GetFamilyImagesInput({
    @required this.pagination,
  }) : assert(pagination != null);

  void toJson() => _$GetFamilyImagesInputToJson(this);
}
