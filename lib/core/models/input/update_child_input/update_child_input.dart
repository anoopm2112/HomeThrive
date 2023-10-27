import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'update_child_input.g.dart';

@JsonSerializable(createFactory: false)
class UpdateChildInput {
  final String id;
  final String image;

  const UpdateChildInput({
    @required this.id,
    this.image,
  }) : assert(id != null);

  void toJson() => _$UpdateChildInputToJson(this);
}
