import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'register_device_input.g.dart';

@JsonSerializable(createFactory: false)
class RegisterDeviceInput {
  final String model;
  final String osVersion;

  @JsonKey(nullable: false)
  final AppPlatform platform;

  @JsonKey(nullable: false)
  final String token;

  const RegisterDeviceInput({
    this.model,
    this.osVersion,
    @required this.platform,
    @required this.token,
  })  : assert(platform != null),
        assert(token != null);

  void toJson() => _$RegisterDeviceInputToJson(this);
}
