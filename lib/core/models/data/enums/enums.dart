import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enums.g.dart';

@HiveType(typeId: 1)
enum MoodRating {
  @HiveField(0)
  @JsonValue("HARDDAY")
  hardDay,

  @HiveField(1)
  @JsonValue("SOSO")
  soso,

  @HiveField(2)
  @JsonValue("AVERAGE")
  average,

  @HiveField(3)
  @JsonValue("GOOD")
  good,

  @HiveField(4)
  @JsonValue("GREAT")
  great,
}

@HiveType(typeId: 2)
enum ChildBehavior {
  @HiveField(0)
  @JsonValue("BEDWETTING")
  bedWetting,

  @HiveField(1)
  @JsonValue("AGRESSION")
  agression,

  @HiveField(2)
  @JsonValue("FOODISSUES")
  food,

  @HiveField(3)
  @JsonValue("DEPRESSION")
  depression,

  @HiveField(4)
  @JsonValue("ANXIETY")
  anxiety,

  @HiveField(5)
  @JsonValue("SCHOOLISSUES")
  schoolIssues,

  @HiveField(6)
  @JsonValue("OTHER")
  other,
}

enum EventParticipantStatus {
  @JsonValue("INVITED")
  invited,

  @JsonValue("ACCEPTED")
  accepted,

  @JsonValue("REJECTED")
  rejected,

  @JsonValue("REQUESTEDCHANGE")
  requestedChange,
}

enum AppPlatform {
  @JsonValue("IOS")
  ios,

  @JsonValue("ANDROID")
  android,
}

enum AppUpdateState {
  @JsonValue("REQUIRED")
  required,

  @JsonValue("RECOMMENDED")
  recommended,

  @JsonValue("NONE")
  none,
}

enum MessageStatus {
  @JsonValue("SENT")
  sent,

  @JsonValue("RECEIVED")
  received,

  @JsonValue("READ")
  read,
}

enum DailyIndoorOutdoorActivity {
  @JsonValue("TEAMWORK")
  teamwork,

  @JsonValue("FITNESS")
  fitness,

  @JsonValue("COORDINATION")
  coordination,

  @JsonValue("COMMUNICATIONSKILL")
  communicationSkill,

  @JsonValue("SOCIALSKILL")
  socialSkill,

  @JsonValue("SELFESTEEM")
  selfesteem,

  @JsonValue("RELATIONAL")
  relational,

  @JsonValue("SHARING")
  sharing,

  @JsonValue("PROBLEMSOLVING")
  problemSolving,

  @JsonValue("HANDEYECOORDINATION")
  handEyeCoordination,

  @JsonValue("IMPULSECONTROL")
  impluseControl,

  @JsonValue("CREATEEXPRESSION")
  createExpression,
}

enum IndividualFreeTImeActivity {
  @JsonValue("STRESSMANAGEMENT")
  stressManagement,

  @JsonValue("HEALTHAUTONOMY")
  healthAutonomy,

  @JsonValue("PERSONALGROWTH")
  personalGrowth,

  @JsonValue("SELFEVALUATION")
  selfEvaluation,

  @JsonValue("CREATEEXPRESSION")
  createExpression,
}

enum CommunityActivity {
  @JsonValue("SOCIALSKILLSPRACTICE")
  socialSkillPractice,

  @JsonValue("CONNECTWITHCULTURE")
  connectWithCulture,

  @JsonValue("INDEPENDENTLIVING")
  independentLiving,

  @JsonValue("SOCIALCONTRIBUTION")
  socialContribution,

  @JsonValue("COMMUNICATIONSKILLS")
  communicationSkills,
}

enum FamilyActivity {
  @JsonValue("FAMILYCOHESION")
  familyCohesion,

  @JsonValue("RELATIONALSKILLS")
  relationalSkills,

  @JsonValue("SENSEOFBELONGING")
  senseOfBelonging,

  @JsonValue("ROLEMODELLIFESKILLS")
  roleModelLifeSkills,

  @JsonValue("SOCIALINTEGRATION")
  socialIntegration,
}
