import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/models/data/log_questions/log_questions.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/ui/views/edit_log_view/log_questions/day_rating_question.dart';
import 'package:fostershare/ui/widgets/user_avatar.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import 'edit_log_view_model.dart';
import 'log_questions/behavioral_question.dart';
import 'log_questions/bio_family_visit_question.dart';
import 'log_questions/childs_mood_question.dart';
import 'log_questions/medication_change_question.dart';
import 'log_questions/parent_mood_question.dart';

class EditLogView extends StatefulWidget {
  final ChildLog childLog;
  final VoidCallback onSubmit;
  final LogQuestion logQuestion;

  EditLogView(this.childLog, {this.onSubmit, this.logQuestion});

  @override
  State<StatefulWidget> createState() => _EditLogView();
}

class _EditLogView extends State<EditLogView> {
  EditLogViewModel model;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return ViewModelBuilder<EditLogViewModel>.reactive(
      viewModelBuilder: () =>
          EditLogViewModel(widget.childLog, widget.onSubmit),
      onModelReady: (model) => model.onModelReady(),
      fireOnModelReadyOnce: false,
      builder: (context, model, child) {
        this.model = model;
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
                        model.childLog.date.toLocal(),
                      )}"),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: ShapeDecoration(
                            color: Color(0xFF009688),
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
                        Text(model.childLog.child.nickName ??
                            model.childLog.child.firstName),
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
                padding: EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  children: [
                    _getViewForQuestion(widget.logQuestion),
                    SizedBox(height: 30),
                    _submitButton(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: model.onTapSubmit,
      child: model.isBusy
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).dialogBackgroundColor,
              ),
            )
          : Text("Submit"),
    );
  }

  _getViewForQuestion(LogQuestion logQuestion) {
    if (logQuestion == LogQuestion.dayRating) {
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
    } else if (logQuestion == LogQuestion.parentMood) {
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
    } else if (logQuestion == LogQuestion.behavioral) {
      return BehavioralQuestion(
        behaviorlIssues: model.fieldValue(
          LogInputField.hasBehavioralIssues,
        ) as bool,
        selectedBehaviors: model.fieldValue(
          LogInputField.behavioral,
        ) as List<ChildBehavior>,
        onHasBehavioralIssuesSelected: (behavioralIssues) =>
            model.updateHasBehaviorIssuesField(
          hasIssue: behavioralIssues,
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
            model.fieldValidationMessage(LogInputField.behavioral),
      );
    } else if (logQuestion == LogQuestion.bioFamilyVisit) {
      return BioFamilyVisitQuestion(
        bioFamilyVisit: model.fieldValue<bool>(
          LogInputField.bioFamilyVisit,
        ),
        onChoiceSelected: (bioFamilyVisit) =>
            model.updateDidVistFamilyField(didVisit: bioFamilyVisit),
        initialComments: model.fieldValue<String>(
          LogInputField.bioFamilyVisitComments,
        ),
        onCommentsChanged: (comments) => model.updateField<String>(
          LogInputField.bioFamilyVisitComments,
          value: comments,
        ),
        errorText: model.fieldValidationMessage(
          LogInputField.bioFamilyVisit,
        ),
      );
    } else if (logQuestion == LogQuestion.childMood) {
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
    } else if (logQuestion == LogQuestion.medication) {
      return MedciationChangeQuestion(
        medicationChange: model.fieldValue<bool>(
          LogInputField.medicationChange,
        ),
        onChoiceSelected: (medicationChange) =>
            model.updateMedicationChangeField(didMedChange: medicationChange),
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
    }
  }
}
