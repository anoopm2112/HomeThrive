import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'create_family_image_input.g.dart';

@JsonSerializable(createFactory: false)
class CreateFamilyImageInput {
  final String name;
  final String image;
  final String file;

  const CreateFamilyImageInput(
      {@required this.name, @required this.image, @required this.file});

  void toJson() => _$CreateFamilyImageInputToJson(this);
}
