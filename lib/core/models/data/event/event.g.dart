// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updateAt: json['updateAt'] == null
        ? null
        : DateTime.parse(json['updateAt'] as String),
    startsAt: json['startsAt'] == null
        ? null
        : DateTime.parse(json['startsAt'] as String),
    endsAt: json['endsAt'] == null
        ? null
        : DateTime.parse(json['endsAt'] as String),
    status:
        _$enumDecodeNullable(_$EventParticipantStatusEnumMap, json['status']),
    eventType: json['eventType'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    image: json['image'] == null ? null : Uri.parse(json['image'] as String),
    venue: json['venue'] as String,
    address: json['address'] as String,
    latitutde: (json['latitutde'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
  );
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$EventParticipantStatusEnumMap = {
  EventParticipantStatus.invited: 'INVITED',
  EventParticipantStatus.accepted: 'ACCEPTED',
  EventParticipantStatus.rejected: 'REJECTED',
  EventParticipantStatus.requestedChange: 'REQUESTEDCHANGE',
};
