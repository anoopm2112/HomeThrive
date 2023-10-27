import 'package:flutter/painting.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/models/input/update_child_log_input/update_child_log_input.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

enum LogInputField {
  dayRating,
  dayRatingComments,
  parentMoodRating,
  parentMoodComments,
  hasBehavioralIssues,
  behavioral,
  behavioralComments,
  bioFamilyVisit,
  bioFamilyVisitComments,
  childMoodRating,
  childMoodComments,
  medicationChange,
  medicationChangeComments,
}

class EditLogViewModel extends BaseViewModel
    with FormViewModelMixin<LogInputField> {
  final ChildLog currentLog;
  ChildLog childLog;
  VoidCallback onSubmit;
  final _navigationService = locator<NavigationService>();
  final _childrenService = locator<ChildrenService>();

  EditLogViewModel(this.currentLog, this.onSubmit);

  Future<void> onModelReady() async {
    setBusy(true);
    childLog = currentLog;
    _addAllFormFields();
    setBusy(false);
  }

  onBack() async {
    await _navigationService.back();
  }

  void updateBehaviorField({
    ChildBehavior behavior,
    String validationMessage,
    String Function(List<ChildBehavior> value) validator,
  }) {
    final List<ChildBehavior> behaviors = List.from(
      this.fieldValue<List<ChildBehavior>>(LogInputField.behavioral),
    );

    if (behaviors.contains(behavior)) {
      behaviors.remove(behavior);
    } else {
      behaviors.add(behavior);
    }

    this.updateField<List<ChildBehavior>>(
      LogInputField.behavioral,
      value: behaviors,
    );
  }

  void updateHasBehaviorIssuesField({
    bool hasIssue,
  }) {
    if (hasIssue == false) {
      this.updateField<List<ChildBehavior>>(
        LogInputField.behavioral,
        value: [],
      );
      this.updateField<String>(
        LogInputField.behavioralComments,
        value: "",
      );
    }
    this.updateField<bool>(
      LogInputField.hasBehavioralIssues,
      value: hasIssue,
    );
  }

  void updateDidVistFamilyField({
    bool didVisit,
  }) {
    if (didVisit == false) {
      this.updateField<String>(
        LogInputField.bioFamilyVisitComments,
        value: "",
      );
    }
    this.updateField<bool>(
      LogInputField.bioFamilyVisit,
      value: didVisit,
    );
  }

  void updateMedicationChangeField({
    bool didMedChange,
  }) {
    this.updateField<bool>(
      LogInputField.medicationChange,
      value: didMedChange,
    );
  }

  @override
  void updateField<T>(
    LogInputField key, {
    T value,
    String validationMessage,
    String Function(T value) validator,
  }) {
    super.updateField<T>(
      key,
      value: value,
      validationMessage: validationMessage,
      validator: validator,
    );

    notifyListeners();
  }

  bool _canSubmit() {
    bool canSubmit = true;
    canSubmit = canSubmit &&
        this.validateField(LogInputField.dayRating) &&
        this.validateField(LogInputField.dayRatingComments);
    canSubmit = canSubmit &&
        this.validateField(LogInputField.parentMoodRating) &&
        this.validateField(LogInputField.parentMoodComments);
    canSubmit = canSubmit &&
        this.validateField(LogInputField.hasBehavioralIssues) &&
        (this.validateField(LogInputField.behavioral) &&
            this.validateField(LogInputField.behavioralComments));
    canSubmit = canSubmit &&
        this.validateField(LogInputField.bioFamilyVisit) &&
        this.validateField(LogInputField.bioFamilyVisitComments);
    canSubmit = canSubmit &&
        this.validateField(LogInputField.childMoodRating) &&
        this.validateField(LogInputField.childMoodComments);
    canSubmit = canSubmit &&
        this.validateField(LogInputField.medicationChange) &&
        this.validateField(LogInputField.medicationChangeComments);
    notifyListeners();
    return canSubmit;
  }

  onTapSubmit() async {
    if (!_canSubmit()) {
      return;
    }
    setBusy(true);
    var result = await _childrenService.updateChildLog(
      UpdateChildLogInput(
        Id: currentLog.id,
        dayRating: this.fieldValue<MoodRating>(
          LogInputField.dayRating,
        ),
        dayRatingComments: this.fieldValue<String>(
          LogInputField.dayRatingComments,
        ),
        parentMoodRating: fieldValue<MoodRating>(
          LogInputField.parentMoodRating,
        ),
        parentMoodComments: this.fieldValue<String>(
          LogInputField.parentMoodComments,
        ),
        behavioralIssues: this
            .fieldValue<List<ChildBehavior>>(
              LogInputField.behavioral,
            )
            //.where((behavior) => behavior != ChildBehavior.other)
            .toList(),
        behavioralIssuesComments: this.fieldValue<String>(
          LogInputField.behavioralComments,
        ),
        familyVisit: this.fieldValue<bool>(
          LogInputField.bioFamilyVisit,
        ),
        familyVisitComments: this.fieldValue<String>(
          LogInputField.bioFamilyVisitComments,
        ),
        childMoodRating: this.fieldValue<MoodRating>(
          LogInputField.childMoodRating,
        ),
        childMoodComments: this.fieldValue<String>(
          LogInputField.childMoodComments,
        ),
        medicationChange: this.fieldValue<bool>(
          LogInputField.medicationChange,
        ),
        medicationChangeComments: this.fieldValue<String>(
          LogInputField.medicationChangeComments,
        ),
      ),
    );
    setBusy(false);
    _navigationService.back<ChildLog>(result: result);
  }

  _addAllFormFields() {
    this.addAllFormFields(
      {
        LogInputField.dayRating: FormFieldModel<MoodRating>(
          value: currentLog.dayRating,
          validator: (rating) =>
              rating == null ? "Please select a rating" : null,
        ),
        LogInputField.dayRatingComments: FormFieldModel<String>(
          value: currentLog.dayRatingComments,
          validator: (dayRatingComments) =>
              dayRatingComments == null || dayRatingComments.trim().isEmpty
                  ? "Please add comments"
                  : null,
        ),
        LogInputField.parentMoodRating: FormFieldModel<MoodRating>(
          value: currentLog.parentMoodRating,
          validator: (rating) =>
              rating == null ? "Please select a rating" : null,
        ),
        LogInputField.parentMoodComments: FormFieldModel<String>(
          value: currentLog.parentMoodComments,
          validator: (parentMoodComments) =>
              parentMoodComments == null || parentMoodComments.trim().isEmpty
                  ? "Please add comments"
                  : null,
        ),
        LogInputField.hasBehavioralIssues: FormFieldModel<bool>(
          value: currentLog.behavioralIssues.isNotEmpty,
          validator: (behavioralIssues) =>
              behavioralIssues == null ? "Please select an option" : null,
        ),
        LogInputField.behavioral: FormFieldModel<List<ChildBehavior>>(
          value: currentLog.behavioralIssues ?? [],
          validator: (childBehavior) => (this
                      .fieldValue<bool>(LogInputField.hasBehavioralIssues) ??
                  false)
              ? (childBehavior != null && childBehavior.isNotEmpty)
                  ? childBehavior.length == 1 &&
                          childBehavior[0] == ChildBehavior.other &&
                          (this.field(LogInputField.behavioralComments).value ==
                                  null ||
                              this
                                  .field<String>(
                                      LogInputField.behavioralComments)
                                  .value
                                  .trim()
                                  .isEmpty)
                      ? "Please add comments"
                      : null
                  : "Option not selected"
              : null,
        ),
        LogInputField.behavioralComments: FormFieldModel<String>(
          value: currentLog.behavioralIssuesComments,
          validator: (comments) =>
              (this.fieldValue<bool>(LogInputField.hasBehavioralIssues) ??
                      false)
                  ? (comments != null && comments.trim().isNotEmpty)
                      ? null
                      : "Please add comments"
                  : null,
        ),
        LogInputField.bioFamilyVisit: FormFieldModel<bool>(
          value: currentLog.familyVisit,
          validator: (bioFamilyVisit) => bioFamilyVisit == null
              ? "Please select a choice"
              : null, // TODO add more for comment
        ),
        LogInputField.bioFamilyVisitComments: FormFieldModel<String>(
          value: currentLog.familyVisitComments,
          validator: (comments) =>
              (this.fieldValue<bool>(LogInputField.bioFamilyVisit) ?? false)
                  ? comments?.trim()?.isNotEmpty ?? false
                      ? null
                      : "Please enter what happened on the visit."
                  : null,
        ),
        LogInputField.childMoodRating: FormFieldModel<MoodRating>(
          value: currentLog.childMoodRating,
          validator: (childMoodRating) =>
              childMoodRating == null ? "Please select a rating." : null,
        ),
        LogInputField.childMoodComments: FormFieldModel<String>(
          value: currentLog.childMoodComments,
          validator: (childMoodComments) =>
              childMoodComments == null || childMoodComments.trim().isEmpty
                  ? "Please add comments"
                  : null,
        ),
        LogInputField.medicationChange: FormFieldModel<bool>(
          value: currentLog.medicationChange,
          validator: (medicationChange) => medicationChange == null
              ? "Please select a choice"
              : null, // TODO add more for comment
        ),
        LogInputField.medicationChangeComments: FormFieldModel<String>(
          value: currentLog.medicationChangeComments,
          validator: (comments) =>
              (this.fieldValue<bool>(LogInputField.medicationChange) ?? false)
                  ? comments?.trim()?.isNotEmpty ?? false
                      ? null
                      : "Please add comments"
                  : null,
        ),
      },
    );
  }
}
