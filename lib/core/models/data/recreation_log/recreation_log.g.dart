// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recreation_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecreationLogAdapter extends TypeAdapter<RecreationLog> {
  @override
  final int typeId = 0;

  @override
  RecreationLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecreationLog();
  }

  @override
  void write(BinaryWriter writer, RecreationLog obj) {
    writer..writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecreationLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecreationLog _$RecreationLogFromJson(Map<String, dynamic> json) {
  return RecreationLog(
    id: json['id'] as String,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    activityComment: json['activityComment'] as String,
    dailyIndoorOutdoorActivity: (json['dailyIndoorOutdoorActivity'] as List)
        ?.map(
            (e) => _$enumDecodeNullable(_$DailyIndoorOutdoorActivityEnumMap, e))
        ?.toList(),
    individualFreeTimeActivity: (json['individualFreeTimeActivity'] as List)
        ?.map(
            (e) => _$enumDecodeNullable(_$IndividualFreeTImeActivityEnumMap, e))
        ?.toList(),
    communityActivity: (json['communityActivity'] as List)
        ?.map((e) => _$enumDecodeNullable(_$CommunityActivityEnumMap, e))
        ?.toList(),
    familyActivity: (json['familyActivity'] as List)
        ?.map((e) => _$enumDecodeNullable(_$FamilyActivityEnumMap, e))
        ?.toList(),
    child: json['child'] == null
        ? null
        : Child.fromJson(json['child'] as Map<String, dynamic>),
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

const _$DailyIndoorOutdoorActivityEnumMap = {
  DailyIndoorOutdoorActivity.teamwork: 'TEAMWORK',
  DailyIndoorOutdoorActivity.fitness: 'FITNESS',
  DailyIndoorOutdoorActivity.coordination: 'COORDINATION',
  DailyIndoorOutdoorActivity.communicationSkill: 'COMMUNICATIONSKILL',
  DailyIndoorOutdoorActivity.socialSkill: 'SOCIALSKILL',
  DailyIndoorOutdoorActivity.selfesteem: 'SELFESTEEM',
  DailyIndoorOutdoorActivity.relational: 'RELATIONAL',
  DailyIndoorOutdoorActivity.sharing: 'SHARING',
  DailyIndoorOutdoorActivity.problemSolving: 'PROBLEMSOLVING',
  DailyIndoorOutdoorActivity.handEyeCoordination: 'HANDEYECOORDINATION',
  DailyIndoorOutdoorActivity.impluseControl: 'IMPULSECONTROL',
  DailyIndoorOutdoorActivity.createExpression: 'CREATEEXPRESSION',
};

const _$IndividualFreeTImeActivityEnumMap = {
  IndividualFreeTImeActivity.stressManagement: 'STRESSMANAGEMENT',
  IndividualFreeTImeActivity.healthAutonomy: 'HEALTHAUTONOMY',
  IndividualFreeTImeActivity.personalGrowth: 'PERSONALGROWTH',
  IndividualFreeTImeActivity.selfEvaluation: 'SELFEVALUATION',
  IndividualFreeTImeActivity.createExpression: 'CREATEEXPRESSION',
};

const _$CommunityActivityEnumMap = {
  CommunityActivity.socialSkillPractice: 'SOCIALSKILLSPRACTICE',
  CommunityActivity.connectWithCulture: 'CONNECTWITHCULTURE',
  CommunityActivity.independentLiving: 'INDEPENDENTLIVING',
  CommunityActivity.socialContribution: 'SOCIALCONTRIBUTION',
  CommunityActivity.communicationSkills: 'COMMUNICATIONSKILLS',
};

const _$FamilyActivityEnumMap = {
  FamilyActivity.familyCohesion: 'FAMILYCOHESION',
  FamilyActivity.relationalSkills: 'RELATIONALSKILLS',
  FamilyActivity.senseOfBelonging: 'SENSEOFBELONGING',
  FamilyActivity.roleModelLifeSkills: 'ROLEMODELLIFESKILLS',
  FamilyActivity.socialIntegration: 'SOCIALINTEGRATION',
};
