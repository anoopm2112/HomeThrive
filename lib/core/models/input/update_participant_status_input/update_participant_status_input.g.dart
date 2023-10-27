// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_participant_status_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$UpdateParticipantStatusInputToJson(
        UpdateParticipantStatusInput instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'status': _$EventParticipantStatusEnumMap[instance.status],
    };

const _$EventParticipantStatusEnumMap = {
  EventParticipantStatus.invited: 'INVITED',
  EventParticipantStatus.accepted: 'ACCEPTED',
  EventParticipantStatus.rejected: 'REJECTED',
  EventParticipantStatus.requestedChange: 'REQUESTEDCHANGE',
};
