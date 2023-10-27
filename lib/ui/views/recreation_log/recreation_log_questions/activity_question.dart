import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/recreation_log/recreation_log_input/recreation_log_input_view_model.dart';
import 'package:fostershare/ui/common/svg_asset_images.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:stacked/stacked.dart';

class ActivityQuestion extends ViewModelWidget<RecreationLogInputViewModel> {
  final List<DailyIndoorOutdoorActivity> selectedDailyIndoorOutdoorActivity;
  final List<IndividualFreeTImeActivity> selectedIndividualFreeTimeActivity;
  final List<CommunityActivity> selectedCommunityActivity;
  final List<FamilyActivity> selectedFamilyActivity;
  final void Function(DailyIndoorOutdoorActivity) onDailyActivitySelected;
  final void Function(IndividualFreeTImeActivity) onFreeTimeActivitySelected;
  final void Function(CommunityActivity) onCommunityActivitySelected;
  final void Function(FamilyActivity) onFamilyActivitySelected;
  final String initialComments;
  final String errorText;

  ActivityQuestion({
    Key key,
    this.selectedDailyIndoorOutdoorActivity,
    this.selectedIndividualFreeTimeActivity,
    this.selectedCommunityActivity,
    this.selectedFamilyActivity,
    this.onDailyActivitySelected,
    this.onFreeTimeActivitySelected,
    this.onCommunityActivitySelected,
    this.onFamilyActivitySelected,
    this.initialComments,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    RecreationLogInputViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    return Column(
      children: [
        TextColumn(
          headline: localization.recreationActivitySelectQuestion,
          subheadline: localization.recreationActivityQuestion,
          error: this.errorText,
        ),
        SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Text(
              localization.dailyIndoorOutdoorActivity,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: getResponsiveMediumFontSize(
                      context,
                    ),
                  ),
            ),
            SizedBox(height: 14),
            SizedBox(
              height: 100,
              child: ListView.separated(
                itemCount: DailyIndoorOutdoorActivity.values.length,
                separatorBuilder: (context, index) => SizedBox(width: 8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final DailyIndoorOutdoorActivity dailyActivity =
                      DailyIndoorOutdoorActivity.values[index];
                  return SelectableButton<DailyIndoorOutdoorActivity>(
                    value: dailyActivity,
                    selected: this.selectedDailyIndoorOutdoorActivity?.contains(
                              dailyActivity,
                            ) ??
                        false,
                    onSelected: this.onDailyActivitySelected,
                    width: 90,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 4,
                        top: 8,
                        right: 4,
                        bottom: 5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            pngImageFromDailyActivity(dailyActivity),
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 6),
                          Text(
                            labelFromDailyActivity(dailyActivity, localization),
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: getResponsiveFontSize(
                                context,
                                fontSize: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 14),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Text(
              localization.individualFreeTimeActivity,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: getResponsiveMediumFontSize(
                      context,
                    ),
                  ),
            ),
            SizedBox(height: 14),
            SizedBox(
              height: 100,
              child: ListView.separated(
                itemCount: IndividualFreeTImeActivity.values.length,
                separatorBuilder: (context, index) => SizedBox(width: 8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final IndividualFreeTImeActivity freeTimeActivity =
                      IndividualFreeTImeActivity.values[index];
                  return SelectableButton<IndividualFreeTImeActivity>(
                    value: freeTimeActivity,
                    selected: this.selectedIndividualFreeTimeActivity?.contains(
                              freeTimeActivity,
                            ) ??
                        false,
                    onSelected: this.onFreeTimeActivitySelected,
                    width: 90,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 4,
                        top: 8,
                        right: 4,
                        bottom: 5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            pngImageFromFreeTimeActivity(freeTimeActivity),
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 6),
                          Text(
                            labelFromFreeTimeActivity(
                                freeTimeActivity, localization),
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: getResponsiveFontSize(
                                context,
                                fontSize: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Text(
              localization.communityActivity,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: getResponsiveMediumFontSize(
                      context,
                    ),
                  ),
            ),
            SizedBox(height: 14),
            SizedBox(
              height: 100,
              child: ListView.separated(
                itemCount: CommunityActivity.values.length,
                separatorBuilder: (context, index) => SizedBox(width: 8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final CommunityActivity communityActivity =
                      CommunityActivity.values[index];
                  return SelectableButton<CommunityActivity>(
                    value: communityActivity,
                    selected: this.selectedCommunityActivity?.contains(
                              communityActivity,
                            ) ??
                        false,
                    onSelected: this.onCommunityActivitySelected,
                    width: 90,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 4,
                        top: 8,
                        right: 4,
                        bottom: 5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            pngImageFromCommunityActivity(communityActivity),
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 6),
                          Text(
                            labelFromCommunityActivity(
                                communityActivity, localization),
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            style: TextStyle(
                              fontSize: getResponsiveFontSize(
                                context,
                                fontSize: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Text(
              localization.familyActivity,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: getResponsiveMediumFontSize(
                      context,
                    ),
                  ),
            ),
            SizedBox(height: 14),
            SizedBox(
              height: 100,
              child: ListView.separated(
                itemCount: FamilyActivity.values.length,
                separatorBuilder: (context, index) => SizedBox(width: 8),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final FamilyActivity familyActivity =
                      FamilyActivity.values[index];
                  return SelectableButton<FamilyActivity>(
                    value: familyActivity,
                    selected: this.selectedFamilyActivity?.contains(
                              familyActivity,
                            ) ??
                        false,
                    onSelected: this.onFamilyActivitySelected,
                    width: 90,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 4,
                        top: 8,
                        right: 4,
                        bottom: 5,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            pngImageFromFamilyActivity(familyActivity),
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 6),
                          Text(
                            labelFromFamilyActivity(
                                familyActivity, localization),
                            textAlign: TextAlign.center,
                            maxLines: 5,
                            style: TextStyle(
                              fontSize: getResponsiveFontSize(
                                context,
                                fontSize: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
