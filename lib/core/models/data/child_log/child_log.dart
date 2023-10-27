import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log_note/child_log_note.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';

part 'child_log.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(createToJson: false)
class ChildLog {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final List<ChildBehavior> behavioralIssues;

  @HiveField(3)
  final String behavioralIssuesComments;

  @HiveField(4)
  final MoodRating dayRating;

  @HiveField(5)
  final String dayRatingComments;

  @HiveField(6)
  final bool familyVisit;

  @HiveField(7)
  final String familyVisitComments;

  @HiveField(8)
  final MoodRating parentMoodRating;

  @HiveField(9)
  final String parentMoodComments;

  @HiveField(10)
  final MoodRating childMoodRating;

  @HiveField(11)
  final String childMoodComments;

  @HiveField(14)
  final bool medicationChange;

  @HiveField(15)
  final String medicationChangeComments;

  @HiveField(12)
  final Child child;

  @HiveField(13)
  final List<ChildLogNote> notes;

  const ChildLog({
    this.id,
    this.date,
    this.behavioralIssues,
    this.behavioralIssuesComments,
    this.dayRating,
    this.dayRatingComments,
    this.familyVisit,
    this.familyVisitComments,
    this.parentMoodRating,
    this.parentMoodComments,
    this.childMoodRating,
    this.childMoodComments,
    this.medicationChange,
    this.medicationChangeComments,
    this.child,
    this.notes = const [],
  });

  factory ChildLog.fromJson(Map<String, dynamic> json) =>
      _$ChildLogFromJson(json);

  ChildLog copyWith({
    String id,
    DateTime date,
    List<ChildBehavior> behavioralIssues,
    String behavioralIssuesComments,
    MoodRating dayRating,
    String dayRatingComments,
    bool familyVisit,
    String familyVisitComments,
    MoodRating parentMoodRating,
    String parentMoodComments,
    MoodRating childMoodRating,
    String childMoodComments,
    Child child,
    List<ChildLogNote> notes,
  }) {
    return ChildLog(
      id: id ?? this.id,
      date: date ?? this.date,
      behavioralIssues: behavioralIssues ?? this.behavioralIssues,
      behavioralIssuesComments:
          behavioralIssuesComments ?? this.behavioralIssuesComments,
      dayRating: dayRating ?? this.dayRating,
      dayRatingComments: dayRatingComments ?? this.dayRatingComments,
      familyVisit: familyVisit ?? this.familyVisit,
      familyVisitComments: familyVisitComments ?? this.familyVisitComments,
      parentMoodRating: parentMoodRating ?? this.parentMoodRating,
      parentMoodComments: parentMoodComments ?? this.parentMoodComments,
      childMoodRating: childMoodRating ?? this.childMoodRating,
      childMoodComments: childMoodComments ?? this.childMoodComments,
      child: child ?? this.child,
      notes: notes ?? this.notes,
    );
  }
}
