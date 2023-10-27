import 'dart:convert';
import 'dart:math';

import 'package:path/path.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/child_log/child_log.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/models/input/create_child_log_image_input/create_child_log_image_input.dart';
import 'package:fostershare/core/models/input/create_child_log_input/create_child_log_input.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/key_value_storage/key_value_storage_service.dart';
import 'package:fostershare/core/services/key_value_storage/utils.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:stacked/stacked.dart';

enum LogInputState {
  dayRating,
  parentMood,
  behavioral,
  bioFamilyVisit,
  childMood,
  medication,
  review,
}

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

class LogInputViewModel extends BaseViewModel
    with FormViewModelMixin<LogInputField> {
  final _childrenService = locator<ChildrenService>();
  final _keyValueStorageService = locator<KeyValueStorageService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final AppLocalizations localization;

  LogInputState _state = LogInputState.dayRating;
  LogInputState get state => _state;

  int get activeIndex => min(
        this._state.index,
        LogInputState.values.length - 2,
      );

  DateTime _date;
  Child _child;
  void Function(ChildLog childLog) _onChildLogChanged;
  PickedFile _imageFile;
  String get selectedImageFileName =>
      this._imageFile != null ? basename(this._imageFile.path) : null;

  LogInputViewModel({
    @required this.localization,
    @required DateTime date,
    @required Child child,
    void Function(ChildLog childLog) onComplete,
  })  : assert(date != null),
        assert(child != null),
        this._date = date.toUtc(),
        this._child = child,
        this._onChildLogChanged = onComplete {
    final String logStorageKey = childLogStorageKey(
      child: this._child,
      date: this._date,
    );
    final String prevLogStorageKey = prevChildLogMapKey(
      date: this._date,
    );

    ChildLog initialChildLog = ChildLog();

    final bool incompleteLog = _keyValueStorageService.containsKey(
      logStorageKey,
    );
    final bool prevChildLog = _keyValueStorageService.containsKey(
      prevLogStorageKey,
    );
    if (incompleteLog) {
      initialChildLog = _keyValueStorageService.get<ChildLog>(
        logStorageKey,
      );
    } else if (prevChildLog) {
      initialChildLog = _keyValueStorageService.get<ChildLog>(
        prevLogStorageKey,
      );
    }
    this.addAllFormFields(
      {
        LogInputField.dayRating: FormFieldModel<MoodRating>(
          value: initialChildLog.dayRating,
          validator: (rating) =>
              rating == null ? localization.selectRating : null,
        ),
        LogInputField.dayRatingComments: FormFieldModel<String>(
          value: initialChildLog.dayRatingComments,
          validator: (dayRatingComments) =>
              dayRatingComments == null || dayRatingComments.trim().isEmpty
                  ? localization.addComments
                  : null,
        ),
        LogInputField.parentMoodRating: FormFieldModel<MoodRating>(
          value: initialChildLog.parentMoodRating,
          validator: (rating) =>
              rating == null ? localization.selectRating : null,
        ),
        LogInputField.parentMoodComments: FormFieldModel<String>(
          value: initialChildLog.parentMoodComments,
          validator: (parentMoodComments) =>
              parentMoodComments == null || parentMoodComments.trim().isEmpty
                  ? localization.addComments
                  : null,
        ),
        LogInputField.hasBehavioralIssues: FormFieldModel<bool>(
          validator: (behavioralIssues) =>
              behavioralIssues == null ? localization.selectOption : null,
        ),
        LogInputField.behavioral: FormFieldModel<List<ChildBehavior>>(
          value: initialChildLog.behavioralIssues ?? [],
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
                      ? localization.addComments
                      : null
                  : localization.selectOption
              : null,
        ),
        LogInputField.behavioralComments: FormFieldModel<String>(
          value: initialChildLog.behavioralIssuesComments,
          validator: (comments) =>
              (this.fieldValue<bool>(LogInputField.hasBehavioralIssues) ??
                      false)
                  ? (comments != null && comments.trim().isNotEmpty)
                      ? null
                      : localization.addComments
                  : null,
        ),
        LogInputField.bioFamilyVisit: FormFieldModel<bool>(
          value: initialChildLog.familyVisit,
          validator: (bioFamilyVisit) => bioFamilyVisit == null
              ? localization.selectChoice
              : null, // TODO add more for comment
        ),
        LogInputField.bioFamilyVisitComments: FormFieldModel<String>(
          value: initialChildLog.familyVisitComments,
          validator: (comments) =>
              (this.fieldValue<bool>(LogInputField.bioFamilyVisit) ?? false)
                  ? comments?.trim()?.isNotEmpty ?? false
                      ? null
                      : localization.whatHappenDuringVisit
                  : null,
        ),
        LogInputField.childMoodRating: FormFieldModel<MoodRating>(
          value: initialChildLog.childMoodRating,
          validator: (childMoodRating) =>
              childMoodRating == null ? localization.selectRating : null,
        ),
        LogInputField.childMoodComments: FormFieldModel<String>(
          value: initialChildLog.childMoodComments,
          validator: (childMoodComments) =>
              childMoodComments == null || childMoodComments.trim().isEmpty
                  ? localization.addComments
                  : null,
        ),
        LogInputField.medicationChange: FormFieldModel<bool>(
          value: initialChildLog.medicationChange,
          validator: (medicationChange) => medicationChange == null
              ? localization.selectChoice
              : null, // TODO add more for comment
        ),
        LogInputField.medicationChangeComments: FormFieldModel<String>(
          value: initialChildLog.medicationChangeComments,
          validator: (comments) =>
              (this.fieldValue<bool>(LogInputField.medicationChange) ?? false)
                  ? comments?.trim()?.isNotEmpty ?? false
                      ? null
                      : localization.addComments
                  : null,
        ),
      },
    );

    if (this.field(LogInputField.medicationChange).validate().valid) {
      this._state = LogInputState.review;
    } else if (this.field(LogInputField.childMoodRating).validate().valid) {
      this._state = LogInputState.medication;
    } else if (this.field(LogInputField.bioFamilyVisit).validate().valid &&
        this.field(LogInputField.bioFamilyVisitComments).validate().valid) {
      this._state = LogInputState.childMood;
    } else if (this.field(LogInputField.hasBehavioralIssues).validate().valid &&
        (this.field(LogInputField.behavioral).validate().valid ||
            this.field(LogInputField.behavioralComments).validate().valid)) {
      this._state = LogInputState.bioFamilyVisit;
    } else if (this.field(LogInputField.parentMoodRating).validate().valid) {
      this._state = LogInputState.behavioral;
    } else if (this.field(LogInputField.dayRating).validate().valid) {
      this._state = LogInputState.parentMood;
    }
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

  void onPrevious() {
    // TODO made it programtic you can't mess up
    _state = LogInputState.values[_state.index - 1];
    notifyListeners();
  }

  void onImageSelected(PickedFile file) {
    _imageFile = file;
  }

  Future<void> onNext() async {
    bool canContinue = false;
    switch (_state) {
      case LogInputState.dayRating:
        canContinue = this.validateField(LogInputField.dayRating) &&
            this.validateField(LogInputField.dayRatingComments);
        if (canContinue) {
          final ChildLog saveChildLog = ChildLog(
              child: this._child,
              date: this._date.toUtc(),
              dayRating: this.fieldValue<MoodRating>(
                LogInputField.dayRating,
              ),
              dayRatingComments: this.fieldValue<String>(
                LogInputField.dayRatingComments,
              ));
          _keyValueStorageService.save(
            key: prevChildLogMapKey(date: this._date),
            value: saveChildLog,
          );
        }
        break;
      case LogInputState.parentMood:
        canContinue = this.validateField(LogInputField.parentMoodRating) &&
            this.validateField(LogInputField.parentMoodComments);
        break;
      case LogInputState.behavioral:
        canContinue = this.validateField(LogInputField.hasBehavioralIssues) &&
            (this.validateField(LogInputField.behavioral) &&
                this.validateField(LogInputField.behavioralComments));
        break;
      case LogInputState.bioFamilyVisit:
        canContinue = this.validateField(LogInputField.bioFamilyVisit) &&
            this.validateField(LogInputField.bioFamilyVisitComments);
        break;
      case LogInputState.childMood:
        canContinue = this.validateField(LogInputField.childMoodRating) &&
            this.validateField(LogInputField.childMoodComments);
        break;
      case LogInputState.medication:
        canContinue = this.validateField(LogInputField.medicationChange) &&
            this.validateField(LogInputField.medicationChangeComments);
        break;
      case LogInputState.review:
        canContinue = true;
        break;
      default:
        break;
    }

    if (canContinue) {
      if (this._state != LogInputState.review) {
        _state = LogInputState.values[_state.index + 1];
        final ChildLog updateChildLog = ChildLog(
          child: this._child,
          date: this._date.toUtc(),
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
          behavioralIssues: this.fieldValue<List<ChildBehavior>>(
            LogInputField.behavioral,
          ),
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
        );
        _keyValueStorageService.save(
          key: childLogStorageKey(child: this._child, date: this._date),
          value: updateChildLog,
        );

        this._onChildLogChanged?.call(updateChildLog);
      } else {
        try {
          this.setBusy(true);

          final ChildLog completedChildLog =
              await _childrenService.createChildLog(
            CreateChildLogInput(
              childId: this._child.id,
              date: this._date.toUtc(),
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
          await _keyValueStorageService
              .delete(childLogStorageKey(child: this._child, date: this._date));

          // final String imageInBase64 = base64.encode(await file.readAsBytes());
          if (_imageFile != null) {
            try {
              final result = await _childrenService.createChildLogImage(
                CreateChildLogImageInput(
                  childLogId: completedChildLog.id,
                  image: base64.encode(await this._imageFile.readAsBytes()),
                  title: basename(this._imageFile.path),
                ),
              );
            } catch (e, s) {
              print(e);
            }
          }

          this._onChildLogChanged?.call(completedChildLog);

          this.setBusy(false);
        } catch (e, s) {
          _loggerService.error(
            "LogInputViewModel - couldn't submit log",
            error: e,
            stackTrace: s,
          );
          // TODO
        }
      }
    }

    notifyListeners();
  }

  Future<bool> onWillPop() async {
    this.onBack();

    return false;
  }

  void onBack() {
    final String logStorageKey = childLogStorageKey(
      child: this._child,
      date: this._date,
    );

    final ChildLog currentLog = _keyValueStorageService.get<ChildLog>(
      logStorageKey,
    );

    _navigationService.back<ChildLog>(result: currentLog);
  }
}
