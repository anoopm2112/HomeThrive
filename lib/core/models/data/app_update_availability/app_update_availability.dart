import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_update_availability.g.dart';

@JsonSerializable(createToJson: false)
class AppUpdateAvailability {
  final AppUpdateState state;
  bool get updateRequired => state == AppUpdateState.required;
  bool get updateRecommended => state == AppUpdateState.recommended;
  bool get updateAvailable => state != AppUpdateState.none;

  final Uri url;

  const AppUpdateAvailability({
    this.state,
    this.url,
  });

  factory AppUpdateAvailability.fromJson(Map<String, dynamic> json) =>
      _$AppUpdateAvailabilityFromJson(json);
}
