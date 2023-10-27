import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/add_log/log_questions/upload_photos_button/upload_photos_button.dart';
import 'package:fostershare/ui/widgets/recreation_log_column.dart';

class RecreationLogReview extends StatelessWidget {
  final String reCreationActivityComments;
  final List<DailyIndoorOutdoorActivity> dailyIndoorOutdoorActivity;
  final List<IndividualFreeTImeActivity> individualFreeTimeActivity;
  final List<CommunityActivity> communityActivity;
  final List<FamilyActivity> familyActivity;

  const RecreationLogReview({
    // TODO pass in child log
    Key key,
    @required this.reCreationActivityComments,
    this.dailyIndoorOutdoorActivity,
    this.individualFreeTimeActivity,
    this.communityActivity,
    this.familyActivity,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final EdgeInsets padding = EdgeInsets.symmetric(horizontal: 16);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: padding,
          child: Text(
            localization.reviewLog,
            style: textTheme.headline1.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: getResponsiveLargeFontSize(context),
            ),
          ),
        ),
        RecreationLogColumn(
          reCreationActivityComments: this.reCreationActivityComments,
          dailyIndoorOutdoorActivity: this.dailyIndoorOutdoorActivity,
          indivitualFreeTimeActivity: this.individualFreeTimeActivity,
          communityActivity: this.communityActivity,
          familyActivity: this.familyActivity,
          endBorder: true,
        ),
      ],
    );
  }
}
