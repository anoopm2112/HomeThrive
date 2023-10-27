import 'package:flutter/material.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/add_log/log_input/log_input_view_model.dart';
import 'package:fostershare/ui/views/add_log/log_questions/behavioral_question.dart';
import 'package:fostershare/ui/views/add_log/log_questions/bio_family_visit_question.dart';
import 'package:fostershare/ui/views/add_log/log_questions/childs_mood_question.dart';
import 'package:fostershare/ui/views/add_log/log_questions/day_rating_question.dart';
import 'package:fostershare/ui/views/add_log/log_questions/log_review.dart';
import 'package:fostershare/ui/views/add_log/log_questions/medication_change_question.dart';
import 'package:fostershare/ui/views/add_log/log_questions/parent_mood_question.dart';
import 'package:fostershare/ui/widgets/user_avatar.dart';
import 'package:fostershare/ui/widgets/circle_painter.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

class LogInputView extends StatelessWidget {
  final DateTime date;
  final Child child;
  final String secondaryAuthorId;
  final void Function(ChildLog childLog) onChildLogChanged;

  const LogInputView({
    Key key,
    @required this.date,
    @required this.child,
    this.secondaryAuthorId, // TODO secondary Auth ID
    this.onChildLogChanged, // TODO asserts
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LogInputViewModel>.reactive(
        viewModelBuilder: () => LogInputViewModel(
              localization: AppLocalizations.of(context),
              date: this.date,
              child: this.child,
              onComplete: this.onChildLogChanged,
            ),
        builder: (context, model, child) {
          final localization = AppLocalizations.of(context);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
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
                              // color: Color(0xFF009688),
                              shape: CircleBorder(
                                  // side: BorderSide(
                                  //   width: 0,
                                  //   color: Theme.of(context).primaryColor,
                                  // ),
                                  ),
                            ),
                            child: Image.asset(
                              PngAssetImages.dailyLog,
                              width: 75.0,
                              height: 75.0,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(height: 5),
                          Text(this.child.nickName ?? this.child.firstName),
                          SizedBox(height: 3),
                          Text(localization.behaviorLog),
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
                  padding:
                      model.state != LogInputState.review // TODO put into model
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
                        count: 6,
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
                                LogInputState.review // TODO put into model
                            ? EdgeInsets.only(
                                left: 16,
                                right: 16,
                              )
                            : EdgeInsets.zero,
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
                                      model.state == LogInputState.review
                                          ? localization.submit
                                          : localization.nextStep,
                                    ),
                            )
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

  Widget _getViewForState(LogInputViewModel model) {
    assert(model != null);

    switch (model.state) {
      case LogInputState.parentMood:
        return ParentMoodQuestion(
          selectedMoodRating: model.fieldValue(
            LogInputField.parentMoodRating,
          ) as MoodRating,
          onMoodRatingSelected: (rating) => model.updateField<MoodRating>(
            LogInputField.parentMoodRating,
            value: rating,
          ),
          initialComments: model.fieldValue<String>(
            LogInputField.parentMoodComments,
          ),
          onCommentsChanged: (comments) => model.updateField<String>(
            LogInputField.parentMoodComments,
            value: comments,
          ),
          errorText: model.fieldValidationMessage(
            LogInputField.parentMoodRating,
          ),
        );
      case LogInputState.behavioral:
        return BehavioralQuestion(
          behaviorlIssues: model.fieldValue(
            LogInputField.hasBehavioralIssues,
          ) as bool,
          selectedBehaviors: model.fieldValue(
            LogInputField.behavioral,
          ) as List<ChildBehavior>,
          onHasBehavioralIssuesSelected: (behavioralIssues) =>
              model.updateField<bool>(
            LogInputField.hasBehavioralIssues,
            value: behavioralIssues,
          ),
          onBehaviorSelected: (behavior) => model.updateBehaviorField(
            behavior: behavior,
          ),
          initialComments: model.fieldValue<String>(
            LogInputField.behavioralComments,
          ),
          onCommentsChanged: (comments) => model.updateField<String>(
            LogInputField.behavioralComments,
            value: comments,
          ),
          errorText: model.fieldValidationMessage(
                LogInputField.hasBehavioralIssues,
              ) ??
              model.fieldValidationMessage(LogInputField.behavioral) ??
              model.fieldValidationMessage(
                LogInputField.behavioralComments,
              ),
        );
      case LogInputState.bioFamilyVisit:
        return BioFamilyVisitQuestion(
          bioFamilyVisit: model.fieldValue<bool>(
            LogInputField.bioFamilyVisit,
          ),
          onChoiceSelected: (bioFamilyVisit) => model.updateField<bool>(
            LogInputField.bioFamilyVisit,
            value: bioFamilyVisit,
          ),
          initialComments: model.fieldValue<String>(
            LogInputField.bioFamilyVisitComments,
          ),
          onCommentsChanged: (comments) => model.updateField<String>(
            LogInputField.bioFamilyVisitComments,
            value: comments,
          ),
          errorText: model.fieldValidationMessage(
                LogInputField.bioFamilyVisit,
              ) ??
              model.fieldValidationMessage(
                LogInputField.bioFamilyVisitComments,
              ),
        );
      case LogInputState.childMood:
        return ChildsMoodQuestion(
          selectedMoodRating: model.fieldValue(
            LogInputField.childMoodRating,
          ) as MoodRating,
          onMoodRatingSelected: (mood) => model.updateField<MoodRating>(
            LogInputField.childMoodRating,
            value: mood,
          ),
          initialComments: model.fieldValue<String>(
            LogInputField.childMoodComments,
          ),
          onCommentsChanged: (comments) => model.updateField<String>(
            LogInputField.childMoodComments,
            value: comments,
          ),
          errorText: model.fieldValidationMessage(
            LogInputField.childMoodRating,
          ),
        );
      case LogInputState.medication:
        return MedciationChangeQuestion(
          medicationChange: model.fieldValue<bool>(
            LogInputField.medicationChange,
          ),
          onChoiceSelected: (medicationChange) => model.updateField<bool>(
            LogInputField.medicationChange,
            value: medicationChange,
          ),
          initialComments: model.fieldValue<String>(
            LogInputField.medicationChangeComments,
          ),
          onCommentsChanged: (comments) => model.updateField<String>(
            LogInputField.medicationChangeComments,
            value: comments,
          ),
          errorText: model.fieldValidationMessage(
            LogInputField.medicationChange,
          ),
        );
      case LogInputState.review:
        return ChildLogReview(
          selectedImageFileName: model.selectedImageFileName,
          onImageSelected: model.onImageSelected,
          dayRating: model.fieldValue<MoodRating>(
            LogInputField.dayRating,
          ),
          dayRatingComments: model.fieldValue<String>(
            LogInputField.dayRatingComments,
          ),
          parentMoodRating: model.fieldValue<MoodRating>(
            LogInputField.parentMoodRating,
          ),
          parentMoodComments: model.fieldValue<String>(
            LogInputField.parentMoodComments,
          ),
          behavioral: model.fieldValue<List<ChildBehavior>>(
            LogInputField.behavioral,
          ),
          behavioralComments: model.fieldValue<String>(
            LogInputField.behavioralComments,
          ),
          familyVisit: model.fieldValue<bool>(
            LogInputField.bioFamilyVisit,
          ),
          familyVisitComments: model.fieldValue<String>(
            LogInputField.bioFamilyVisitComments,
          ),
          childMoodRating: model.fieldValue<MoodRating>(
            LogInputField.childMoodRating,
          ),
          childMoodComments: model.fieldValue<String>(
            LogInputField.childMoodComments,
          ),
          medicationChange: model.fieldValue<bool>(
            LogInputField.medicationChange,
          ),
          medicationChangeComments: model.fieldValue<String>(
            LogInputField.medicationChangeComments,
          ),
        );
      case LogInputState.dayRating:
      default:
        return DayRatingQuestion(
          selectedMoodRating:
              model.fieldValue(LogInputField.dayRating) as MoodRating,
          onMoodRatingSelected: (rating) => model.updateField<MoodRating>(
            LogInputField.dayRating,
            value: rating,
          ),
          initialComments: model.fieldValue<String>(
            LogInputField.dayRatingComments,
          ),
          onCommentsChanged: (comments) => model.updateField<String>(
            LogInputField.dayRatingComments,
            value: comments,
          ),
          errorText: model.fieldValidationMessage(LogInputField.dayRating),
        );
    }
  }
}
