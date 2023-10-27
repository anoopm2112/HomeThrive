import 'package:flutter/material.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/recreation_log/recreation_log_input/recreation_log_input_view_model.dart';
import 'package:fostershare/ui/views/recreation_log/recreation_log_questions/recreation_activity_question.dart';
import 'package:fostershare/ui/views/recreation_log/recreation_log_questions/activity_question.dart';
import 'package:fostershare/ui/views/recreation_log/recreation_log_questions/recreation_log_review.dart';
import 'package:fostershare/ui/widgets/user_avatar.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

class RecreationLogInputView extends StatelessWidget {
  final DateTime date;
  final Child child;
  final String secondaryAuthorId;
  final void Function(RecreationLog recLog) onRecLogChanged;

  const RecreationLogInputView({
    Key key,
    @required this.date,
    @required this.child,
    this.secondaryAuthorId, // TODO secondary Auth ID
    this.onRecLogChanged, // TODO asserts
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RecreationLogInputViewModel>.reactive(
        viewModelBuilder: () => RecreationLogInputViewModel(
              localization: AppLocalizations.of(context),
              date: this.date,
              child: this.child,
              onComplete: this.onRecLogChanged,
            ),
        builder: (context, model, child) {
          final localization = AppLocalizations.of(context);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 25,
                  left: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: model.onBack,
                          child: Icon(
                            Icons.close,
                            size: 32,
                            color: Color(0xFF95A1AC), // TODO
                          ),
                        ),
                        Text("${DateFormat.MMMEd().format(
                          this.date.toLocal(),
                        )}"),
                      ],
                    ),
                    Center(
                      child: Column(
                        children: [
                          // UserAvatar(
                          //   image: NetworkImage(this.child.imageURL.toString()),
                          //   radius: 45,
                          // ),
                          Container(
                            decoration: ShapeDecoration(
                              //color: Color(0xFF95A1AC),
                              shape: CircleBorder(
                                  // side: BorderSide(
                                  //   width: 0,
                                  //   color: Theme.of(context).primaryColor,
                                  // ),
                                  ),
                            ),
                            child: Image.asset(
                              PngAssetImages.recLog,
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(this.child.nickName ?? this.child.firstName),
                          SizedBox(height: 3),
                          Text(localization.recreationLog),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Divider(
                height: 0,
                color: Color(0xFFDEE2E7), // TODO
                thickness: 1,
              ),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: model.state !=
                          RecreationLogInputState.review // TODO put into model
                      ? EdgeInsets.only(
                          left: 16,
                          top: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          // bottom: 16,
                        )
                      : EdgeInsets.only(
                          bottom: 16,
                        ),
                  child: Column(
                    children: [
                      _getViewForState(model),
                      SizedBox(height: 28),
                      AnimatedSmoothIndicator(
                        activeIndex: model.activeIndex,
                        count: 2,
                        effect: WormEffect(
                          dotWidth: 20,
                          dotHeight: 10,
                          radius: 5,
                          activeDotColor: Theme.of(context).primaryColor,
                          dotColor: Color(0xFFDBE2E7), // TODO
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: model.state ==
                                RecreationLogInputState
                                    .review // TODO put into model
                            ? EdgeInsets.only(
                                left: 16,
                                right: 16,
                              )
                            : EdgeInsets.only(bottom: 25),
                        child: Row(
                          children: [
                            if (model.state.index != 0)
                              OutlinedButton(
                                // TODO make into widget
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    width: 2,
                                    color: Color(0xFFE6E6E6),
                                  ),
                                ),
                                onPressed: model.onPrevious,
                                child: Text(
                                  localization.previous,
                                  style: TextStyle(
                                    color: Color(0xFF57636C), // TODO
                                  ),
                                ),
                              ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            ElevatedButton(
                              onPressed: model.isBusy ? null : model.onNext,
                              child: model.isBusy
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).dialogBackgroundColor,
                                      ),
                                    )
                                  : Text(
                                      model.state ==
                                              RecreationLogInputState.review
                                          ? localization.submit
                                          : localization.nextStep,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget _getViewForState(RecreationLogInputViewModel model) {
    assert(model != null);

    switch (model.state) {
      case RecreationLogInputState.selectActivities:
        return ActivityQuestion(
          selectedDailyIndoorOutdoorActivity: model.fieldValue(
            RecreationLogInputField.dailyIndoorOutdoorActivity,
          ) as List<DailyIndoorOutdoorActivity>,
          onDailyActivitySelected: (dailyActivity) =>
              model.updateDailyActivityField(
            dailyActivity: dailyActivity,
          ),
          selectedIndividualFreeTimeActivity: model.fieldValue(
            RecreationLogInputField.indivitualFreeTimeActivity,
          ) as List<IndividualFreeTImeActivity>,
          onFreeTimeActivitySelected: (freeTimeActivity) =>
              model.updateFreeTimeActivityField(
            freeTimeActivity: freeTimeActivity,
          ),
          selectedCommunityActivity: model.fieldValue(
            RecreationLogInputField.communityActivity,
          ) as List<CommunityActivity>,
          onCommunityActivitySelected: (comminityActivity) =>
              model.updateCommunityActivityField(
            communityActivity: comminityActivity,
          ),
          selectedFamilyActivity: model.fieldValue(
            RecreationLogInputField.familyActivity,
          ) as List<FamilyActivity>,
          onFamilyActivitySelected: (familyActivity) =>
              model.updateFamilyActivityField(
            familyActivity: familyActivity,
          ),
        );
      case RecreationLogInputState.review:
        return RecreationLogReview(
          reCreationActivityComments: model.fieldValue<String>(
            RecreationLogInputField.reCreationActivityComments,
          ),
          dailyIndoorOutdoorActivity:
              model.fieldValue<List<DailyIndoorOutdoorActivity>>(
            RecreationLogInputField.dailyIndoorOutdoorActivity,
          ),
          individualFreeTimeActivity:
              model.fieldValue<List<IndividualFreeTImeActivity>>(
            RecreationLogInputField.indivitualFreeTimeActivity,
          ),
          communityActivity: model.fieldValue<List<CommunityActivity>>(
            RecreationLogInputField.communityActivity,
          ),
          familyActivity: model.fieldValue<List<FamilyActivity>>(
            RecreationLogInputField.familyActivity,
          ),
        );
      case RecreationLogInputState.activityComments:
      default:
        return RecreationActivityQuestion(
          initialComments: model.fieldValue<String>(
            RecreationLogInputField.reCreationActivityComments,
          ),
          onCommentsChanged: (comments) => model.updateField<String>(
            RecreationLogInputField.reCreationActivityComments,
            value: comments,
          ),
          errorText: model.fieldValidationMessage(
              RecreationLogInputField.reCreationActivityComments),
        );
    }
  }
}
