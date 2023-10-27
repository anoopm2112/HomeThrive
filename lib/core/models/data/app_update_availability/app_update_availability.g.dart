// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUpdateAvailability _$AppUpdateAvailabilityFromJson(
    Map<String, dynamic> json) {
  return AppUpdateAvailability(
    state: _$enumDecodeNullable(_$AppUpdateStateEnumMap, json['state']),
    url: json['url'] == null ? null : Uri.parse(json['url'] as String),
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

const _$AppUpdateStateEnumMap = {
  AppUpdateState.required: 'REQUIRED',
  AppUpdateState.recommended: 'RECOMMENDED',
  AppUpdateState.none: 'NONE',
};
