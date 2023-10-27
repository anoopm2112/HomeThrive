import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'get_app_update_availability_input.g.dart';

@JsonSerializable(createFactory: false)
class GetAppUpdateAvailabilityInput {
  final AppPlatform platform;
  final String version;

  const GetAppUpdateAvailabilityInput({
    @required this.platform,
    @required this.version,
  })  : assert(platform != null),
        assert(version != null);

  void toJson() => _$GetAppUpdateAvailabilityInputToJson(this);
}
