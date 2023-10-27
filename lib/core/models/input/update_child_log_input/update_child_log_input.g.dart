// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_child_log_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$UpdateChildLogInputToJson(
        UpdateChildLogInput instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'dayRating': _$MoodRatingEnumMap[instance.dayRating],
      'dayRatingComments': instance.dayRatingComments,
      'parentMoodRating': _$MoodRatingEnumMap[instance.parentMoodRating],
      'parentMoodComments': instance.parentMoodComments,
      'behavioralIssues': instance.behavioralIssues
          ?.map((e) => _$ChildBehaviorEnumMap[e])
          ?.toList(),
      'behavioralIssuesComments': instance.behavioralIssuesComments,
      'familyVisit': instance.familyVisit,
      'familyVisitComments': instance.familyVisitComments,
      'childMoodRating': _$MoodRatingEnumMap[instance.childMoodRating],
      'childMoodComments': instance.childMoodComments,
      'medicationChange': instance.medicationChange,
      'medicationChangeComments': instance.medicationChangeComments,
    };

const _$MoodRatingEnumMap = {
  MoodRating.hardDay: 'HARDDAY',
  MoodRating.soso: 'SOSO',
  MoodRating.average: 'AVERAGE',
  MoodRating.good: 'GOOD',
  MoodRating.great: 'GREAT',
};

const _$ChildBehaviorEnumMap = {
  ChildBehavior.bedWetting: 'BEDWETTING',
  ChildBehavior.agression: 'AGRESSION',
  ChildBehavior.food: 'FOODISSUES',
  ChildBehavior.depression: 'DEPRESSION',
  ChildBehavior.anxiety: 'ANXIETY',
  ChildBehavior.schoolIssues: 'SCHOOLISSUES',
  ChildBehavior.other: 'OTHER',
};
