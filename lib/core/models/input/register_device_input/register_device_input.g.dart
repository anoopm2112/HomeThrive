// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_device_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$RegisterDeviceInputToJson(
        RegisterDeviceInput instance) =>
    <String, dynamic>{
      'model': instance.model,
      'osVersion': instance.osVersion,
      'platform': _$AppPlatformEnumMap[instance.platform],
      'token': instance.token,
    };

const _$AppPlatformEnumMap = {
  AppPlatform.ios: 'IOS',
  AppPlatform.android: 'ANDROID',
};
