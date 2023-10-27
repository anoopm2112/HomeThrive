import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';

part 'recreation_log.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(createToJson: false)
class RecreationLog {
  final String id;
  final DateTime createdAt;
  final String activityComment;
  final List<DailyIndoorOutdoorActivity> dailyIndoorOutdoorActivity;
  final List<IndividualFreeTImeActivity> individualFreeTimeActivity;
  final List<CommunityActivity> communityActivity;
  final List<FamilyActivity> familyActivity;
  final Child child;

  const RecreationLog({
    this.id,
    this.createdAt,
    this.activityComment,
    this.dailyIndoorOutdoorActivity,
    this.individualFreeTimeActivity,
    this.communityActivity,
    this.familyActivity,
    this.child,
  });

  factory RecreationLog.fromJson(Map<String, dynamic> json) =>
      _$RecreationLogFromJson(json);

  /*RecreationLog copyWith({
    String id,
    DateTime date,
    String reCreationActivityComments,
    List<DailyIndoorOutdoorActivity> dailyIndoorOutdoorActivity,
    List<IndividualFreeTImeActivity> indivitualFreeTimeActivity,
    List<CommunityActivity> communityActivity,
    List<FamilyActivity> familyActivity,
    Child child,
  }) {
    return RecreationLog(
      id: id ?? this.id,
      date: date ?? this.date,
      reCreationActivityComments:
          reCreationActivityComments ?? this.reCreationActivityComments,
      dailyIndoorOutdoorActivity:
          dailyIndoorOutdoorActivity ?? this.dailyIndoorOutdoorActivity,
      indivitualFreeTimeActivity:
          indivitualFreeTimeActivity ?? this.indivitualFreeTimeActivity,
      communityActivity: communityActivity ?? this.communityActivity,
      familyActivity: familyActivity ?? this.familyActivity,
      child: child ?? this.child,
    );
  }*/
}
