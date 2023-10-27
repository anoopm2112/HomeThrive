import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'update_child_nickname_input.g.dart';

@JsonSerializable(createFactory: false)
class UpdateChildNickNameInput {
  final String id;
  final String nickName;

  const UpdateChildNickNameInput({
    @required this.id,
    this.nickName,
  }) : assert(id != null);

  void toJson() => _$UpdateChildNickNameInputToJson(this);
}
