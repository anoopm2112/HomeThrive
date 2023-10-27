import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'update_child_log_input.g.dart';

@JsonSerializable(createFactory: false)
class UpdateChildLogInput {
  final String Id;
  final MoodRating dayRating;
  final String dayRatingComments;
  final MoodRating parentMoodRating;
  final String parentMoodComments;
  final List<ChildBehavior> behavioralIssues;
  final String behavioralIssuesComments;
  final bool familyVisit;
  final String familyVisitComments;
  final MoodRating childMoodRating;
  final String childMoodComments;
  final bool medicationChange;
  final String medicationChangeComments;

  const UpdateChildLogInput({
    @required this.Id,
    @required this.dayRating,
    this.dayRatingComments,
    @required this.parentMoodRating,
    this.parentMoodComments,
    this.behavioralIssues,
    this.behavioralIssuesComments,
    @required this.familyVisit,
    this.familyVisitComments,
    @required this.childMoodRating,
    this.childMoodComments,
    @required this.medicationChange,
    this.medicationChangeComments,
  })  : assert(dayRating != null),
        assert(parentMoodRating != null),
        assert(familyVisit != null),
        assert(childMoodRating != null),
        assert(medicationChange != null);

  void toJson() => _$UpdateChildLogInputToJson(this);
}
