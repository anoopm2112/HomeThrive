import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'create_child_log_image_input.g.dart';

@JsonSerializable(createFactory: false)
class CreateChildLogImageInput {
  final String childLogId;
  final String image;
  final String title;

  const CreateChildLogImageInput({
    @required this.childLogId,
    @required this.image,
    @required this.title,
  })  : assert(childLogId != null),
        assert(image != null),
        assert(title != null);

  void toJson() => _$CreateChildLogImageInputToJson(this);
}
