import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'update_participant_status_input.g.dart';

@JsonSerializable(createFactory: false)
class UpdateParticipantStatusInput {
  final String eventId;
  final EventParticipantStatus status;

  const UpdateParticipantStatusInput({
    @required this.eventId,
    @required this.status,
  })  : assert(eventId != null),
        assert(status != null);

  void toJson() => _$UpdateParticipantStatusInputToJson(this);
}
