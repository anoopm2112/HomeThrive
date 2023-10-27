import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'create_recreation_log_input.g.dart';

@JsonSerializable(createFactory: false)
class CreateRecreationLogInput {
  final String childId;
  //final String secondaryAuthorId;
  final DateTime date;
  final String activityComment;
  final List<DailyIndoorOutdoorActivity> dailyIndoorOutdoorActivity;
  final List<IndividualFreeTImeActivity> individualFreeTimeActivity;
  final List<CommunityActivity> communityActivity;
  final List<FamilyActivity> familyActivity;

  const CreateRecreationLogInput({
    @required this.childId,
    //this.secondaryAuthorId,
    @required this.date,
    @required this.activityComment,
    this.dailyIndoorOutdoorActivity,
    this.individualFreeTimeActivity,
    this.communityActivity,
    this.familyActivity,
  })  : assert(childId != null),
        assert(date != null),
        assert(activityComment != null),
        assert(dailyIndoorOutdoorActivity != null),
        assert(individualFreeTimeActivity != null),
        assert(communityActivity != null),
        assert(familyActivity != null);

  void toJson() => _$CreateRecreationLogInputToJson(this);
}
