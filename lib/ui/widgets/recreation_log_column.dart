import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/string_utils.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/common/svg_asset_images.dart';
import 'package:fostershare/ui/views/recreation_log/recreation_log_summary/recreation_log_summary_view.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

// TODO take in childlog as a parameter
class RecreationLogColumn extends StatelessWidget {
  final String reCreationActivityComments;
  final VoidCallback onTapRecActivity;
  final List<DailyIndoorOutdoorActivity> dailyIndoorOutdoorActivity;
  final VoidCallback onTapFreeTimeActivity;
  final List<IndividualFreeTImeActivity> indivitualFreeTimeActivity;
  final VoidCallback onTapCommunityActivity;
  final List<CommunityActivity> communityActivity;
  final VoidCallback onTapFamilyActivity;
  final List<FamilyActivity> familyActivity;
  final bool endBorder;

  const RecreationLogColumn({
    Key key,
    this.reCreationActivityComments,
    this.dailyIndoorOutdoorActivity,
    this.onTapRecActivity,
    this.indivitualFreeTimeActivity,
    this.onTapFreeTimeActivity,
    this.communityActivity,
    this.onTapCommunityActivity,
    this.familyActivity,
    this.onTapFamilyActivity,
    this.endBorder = false,
  })  : assert(endBorder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Column(
      children: [
        RecreationLogQuestionSummary(
          question: localization.recreationActivitySubQuestion,
          comments: this.reCreationActivityComments,
          bottomBorder: true,
        ),
        GestureDetector(
          onTap: onTapRecActivity,
          child: RecreationLogQuestionSummary.textAnswer(
            question: localization.dailyIndoorOutdoorActivity,
            center: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: this
                  .dailyIndoorOutdoorActivity
                  .map<Widget>(
                    (dailyActivity) => SelectableButton(
                      selected: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              pngImageFromDailyActivity(dailyActivity),
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                labelFromDailyActivity(
                                  dailyActivity,
                                  localization,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: getResponsiveSmallFontSize(
                                        context,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            //comments: this.behavioralComments,
            bottomBorder: true,
          ),
        ),
        GestureDetector(
          onTap: onTapFreeTimeActivity,
          child: RecreationLogQuestionSummary.textAnswer(
            question: localization.individualFreeTimeActivity,
            center: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: this
                  .indivitualFreeTimeActivity
                  .map<Widget>(
                    (freeTimeActivity) => SelectableButton(
                      selected: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              pngImageFromFreeTimeActivity(freeTimeActivity),
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                labelFromFreeTimeActivity(
                                  freeTimeActivity,
                                  localization,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: getResponsiveSmallFontSize(
                                        context,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            //comments: this.behavioralComments,
            bottomBorder: true,
          ),
        ),
        GestureDetector(
          onTap: onTapCommunityActivity,
          child: RecreationLogQuestionSummary.textAnswer(
            question: localization.communityActivity,
            center: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: this
                  .communityActivity
                  .map<Widget>(
                    (communityActivity) => SelectableButton(
                      selected: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              pngImageFromCommunityActivity(communityActivity),
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                labelFromCommunityActivity(
                                  communityActivity,
                                  localization,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: getResponsiveSmallFontSize(
                                        context,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            //comments: this.behavioralComments,
            bottomBorder: true,
          ),
        ),
        GestureDetector(
          onTap: onTapFamilyActivity,
          child: RecreationLogQuestionSummary.textAnswer(
            question: localization.familyActivity,
            center: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: this
                  .familyActivity
                  .map<Widget>(
                    (familyActivity) => SelectableButton(
                      selected: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              pngImageFromFamilyActivity(familyActivity),
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                labelFromFamilyActivity(
                                  familyActivity,
                                  localization,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: getResponsiveSmallFontSize(
                                        context,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            //comments: this.behavioralComments,
            bottomBorder: true,
          ),
        ),
      ],
    );
  }
}
