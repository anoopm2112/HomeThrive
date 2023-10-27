// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_recreation_log_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$CreateRecreationLogInputToJson(
        CreateRecreationLogInput instance) =>
    <String, dynamic>{
      'childId': instance.childId,
      'date': instance.date?.toIso8601String(),
      'activityComment': instance.activityComment,
      'dailyIndoorOutdoorActivity': instance.dailyIndoorOutdoorActivity
          ?.map((e) => _$DailyIndoorOutdoorActivityEnumMap[e])
          ?.toList(),
      'individualFreeTimeActivity': instance.individualFreeTimeActivity
          ?.map((e) => _$IndividualFreeTImeActivityEnumMap[e])
          ?.toList(),
      'communityActivity': instance.communityActivity
          ?.map((e) => _$CommunityActivityEnumMap[e])
          ?.toList(),
      'familyActivity': instance.familyActivity
          ?.map((e) => _$FamilyActivityEnumMap[e])
          ?.toList(),
    };

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
