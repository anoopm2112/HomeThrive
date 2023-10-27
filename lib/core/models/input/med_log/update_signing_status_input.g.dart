// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_signing_status_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$UpdateSigningStatusInputToJson(
        UpdateSigningStatusInput instance) =>
    <String, dynamic>{
      'medLogId': instance.medLogId,
      'status': _$SigningStatusEnumMap[instance.status],
    };

const _$SigningStatusEnumMap = {
  SigningStatus.PENDING: 'PENDING',
  SigningStatus.DRAFT: 'DRAFT',
  SigningStatus.SENT: 'SENT',
  SigningStatus.DELIVERED: 'DELIVERED',
  SigningStatus.COMPLETED: 'COMPLETED',
  SigningStatus.DECLINED: 'DECLINED',
  SigningStatus.VOIDED: 'VOIDED',
};
