import 'dart:convert';
import 'dart:math';

import 'package:path/path.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/recreation_log/recreation_log.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/models/input/create_recreation_log_input/create_recreation_log_input.dart';
import 'package:fostershare/core/services/recreaction_log_services.dart';
import 'package:fostershare/core/services/key_value_storage/key_value_storage_service.dart';
import 'package:fostershare/core/services/key_value_storage/utils.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/core/services/bottom_sheet/bottom_sheet_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:stacked/stacked.dart';

enum RecreationLogInputState {
  activityComments,
  selectActivities,
  review,
}

enum RecreationLogInputField {
  reCreationActivityComments,
  dailyIndoorOutdoorActivity,
  indivitualFreeTimeActivity,
  communityActivity,
  familyActivity,
}

class RecreationLogInputViewModel extends BaseViewModel
    with FormViewModelMixin<RecreationLogInputField> {
  final _recLogService = locator<RecreationLogService>();
  final _keyValueStorageService = locator<KeyValueStorageService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final AppLocalizations localization;
  final String _submitting = "SigningInKey";
  bool get submitting => this.busy(this._submitting);

  RecreationLogInputState _state = RecreationLogInputState.activityComments;
  RecreationLogInputState get state => _state;

  int get activeIndex => min(
        this._state.index,
        RecreationLogInputState.values.length - 2,
      );

  DateTime _date;
  Child _child;
  void Function(RecreationLog recLog) _onRecLogChanged;
  PickedFile _imageFile;
  String get selectedImageFileName =>
      this._imageFile != null ? basename(this._imageFile.path) : null;

  RecreationLogInputViewModel({
    @required this.localization,
    @required DateTime date,
    @required Child child,
    void Function(RecreationLog recLog) onComplete,
  })  : assert(date != null),
        assert(child != null),
        this._date = date.toUtc(),
        this._child = child,
        this._onRecLogChanged = onComplete {
    final String logStorageKey = childLogStorageKey(
      child: this._child,
      date: this._date,
    );

    RecreationLog initialRecLog = RecreationLog();

    // final bool incompleteLog = _keyValueStorageService.containsKey(
    //   logStorageKey,
    // );
    // if (incompleteLog) {
    //   initialRecLog = _keyValueStorageService.get<RecreationLog>(
    //     logStorageKey,
    //   );
    // }
    this.addAllFormFields(
      {
        RecreationLogInputField.reCreationActivityComments:
            FormFieldModel<String>(
          value: initialRecLog.activityComment,
          validator: (reCreationActivityComments) =>
              reCreationActivityComments == null ||
                      reCreationActivityComments.trim().isEmpty
                  ? localization.addComments
                  : null,
        ),
        RecreationLogInputField.dailyIndoorOutdoorActivity:
            FormFieldModel<List<DailyIndoorOutdoorActivity>>(
          value: initialRecLog.dailyIndoorOutdoorActivity ?? [],
          validator: (dailyActivity) => dailyActivity == null ? null : null,
        ),
        RecreationLogInputField.indivitualFreeTimeActivity:
            FormFieldModel<List<IndividualFreeTImeActivity>>(
          value: initialRecLog.individualFreeTimeActivity ?? [],
          validator: (freeTimeActivity) =>
              freeTimeActivity == null ? null : null,
        ),
        RecreationLogInputField.communityActivity:
            FormFieldModel<List<CommunityActivity>>(
          value: initialRecLog.communityActivity ?? [],
          validator: (communityActivity) =>
              communityActivity == null ? null : null,
        ),
        RecreationLogInputField.familyActivity:
            FormFieldModel<List<FamilyActivity>>(
          value: initialRecLog.familyActivity ?? [],
          validator: (FamilyActivity) => FamilyActivity == null ? null : null,
        ),
      },
    );
  }
  @override
  void updateField<T>(
    RecreationLogInputField key, {
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

  void onPrevious() {
    // TODO made it programtic you can't mess up
    _state = RecreationLogInputState.values[_state.index - 1];
    notifyListeners();
  }

  void onImageSelected(PickedFile file) {
    _imageFile = file;
  }

  Future<void> onNext() async {
    bool canContinue = false;
    switch (_state) {
      case RecreationLogInputState.activityComments:
        canContinue = this.validateField(
                RecreationLogInputField.reCreationActivityComments) &&
            this.validateField(
                RecreationLogInputField.reCreationActivityComments);
        break;
      case RecreationLogInputState.selectActivities:
        // canContinue = this.validateField(RecreationLogInputField.dayRating) &&
        //     this.validateField(RecreationLogInputField.dayRatingComments);
        canContinue = true;
        break;
      case RecreationLogInputState.review:
        canContinue = true;
        break;
      default:
        break;
    }

    if (canContinue) {
      if (this._state != RecreationLogInputState.review) {
        _state = RecreationLogInputState.values[_state.index + 1];
        /*final ChildLog updateChildLog = ChildLog(
          child: this._child,
          date: this._date.toUtc(),
          dayRating: this.fieldValue<MoodRating>(
            RecreationLogInputField.dayRating,
          ),
          dayRatingComments: this.fieldValue<String>(
            RecreationLogInputField.dayRatingComments,
          ),
          parentMoodRating: fieldValue<MoodRating>(
            RecreationLogInputField.parentMoodRating,
          ),
          parentMoodComments: this.fieldValue<String>(
            RecreationLogInputField.parentMoodComments,
          ),
          behavioralIssues: this.fieldValue<List<ChildBehavior>>(
            RecreationLogInputField.behavioral,
          ),
          behavioralIssuesComments: this.fieldValue<String>(
            RecreationLogInputField.behavioralComments,
          ),
          familyVisit: this.fieldValue<bool>(
            RecreationLogInputField.bioFamilyVisit,
          ),
          familyVisitComments: this.fieldValue<String>(
            RecreationLogInputField.bioFamilyVisitComments,
          ),
          childMoodRating: this.fieldValue<MoodRating>(
            RecreationLogInputField.childMoodRating,
          ),
          childMoodComments: this.fieldValue<String>(
            RecreationLogInputField.childMoodComments,
          ),
          medicationChange: this.fieldValue<bool>(
            RecreationLogInputField.medicationChange,
          ),
          medicationChangeComments: this.fieldValue<String>(
            RecreationLogInputField.medicationChangeComments,
          ),
        );
        _keyValueStorageService.save(
          key: childLogStorageKey(child: this._child, date: this._date),
          value: updateChildLog,
        );

        this._onChildLogChanged?.call(updateChildLog);*/
      } else {
        try {
          this.setBusy(true);
          final RecreationLog completedRecLog =
              await _recLogService.createRecreationLog(
            CreateRecreationLogInput(
              childId: this._child.id,
              date: this._date.toUtc(),
              activityComment: this.fieldValue<String>(
                RecreationLogInputField.reCreationActivityComments,
              ),
              dailyIndoorOutdoorActivity:
                  fieldValue<List<DailyIndoorOutdoorActivity>>(
                RecreationLogInputField.dailyIndoorOutdoorActivity,
              ),
              individualFreeTimeActivity:
                  fieldValue<List<IndividualFreeTImeActivity>>(
                RecreationLogInputField.indivitualFreeTimeActivity,
              ),
              communityActivity: fieldValue<List<CommunityActivity>>(
                RecreationLogInputField.communityActivity,
              ),
              familyActivity: fieldValue<List<FamilyActivity>>(
                RecreationLogInputField.familyActivity,
              ),
            ),
          );
          this.setBusy(false);
          _navigationService.back<RecreationLog>(result: completedRecLog);
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

  void updateDailyActivityField({
    DailyIndoorOutdoorActivity dailyActivity,
    String validationMessage,
    String Function(List<DailyIndoorOutdoorActivity> value) validator,
  }) {
    final List<DailyIndoorOutdoorActivity> behaviors = List.from(
      this.fieldValue<List<DailyIndoorOutdoorActivity>>(
          RecreationLogInputField.dailyIndoorOutdoorActivity),
    );

    if (behaviors.contains(dailyActivity)) {
      behaviors.remove(dailyActivity);
    } else {
      behaviors.add(dailyActivity);
    }

    this.updateField<List<DailyIndoorOutdoorActivity>>(
      RecreationLogInputField.dailyIndoorOutdoorActivity,
      value: behaviors,
    );
  }

  void updateFreeTimeActivityField({
    IndividualFreeTImeActivity freeTimeActivity,
    String validationMessage,
    String Function(List<IndividualFreeTImeActivity> value) validator,
  }) {
    final List<IndividualFreeTImeActivity> freeTimesActivity = List.from(
      this.fieldValue<List<IndividualFreeTImeActivity>>(
          RecreationLogInputField.indivitualFreeTimeActivity),
    );

    if (freeTimesActivity.contains(freeTimeActivity)) {
      freeTimesActivity.remove(freeTimeActivity);
    } else {
      freeTimesActivity.add(freeTimeActivity);
    }

    this.updateField<List<IndividualFreeTImeActivity>>(
      RecreationLogInputField.indivitualFreeTimeActivity,
      value: freeTimesActivity,
    );
  }

  void updateCommunityActivityField({
    CommunityActivity communityActivity,
    String validationMessage,
    String Function(List<CommunityActivity> value) validator,
  }) {
    final List<CommunityActivity> communityActivities = List.from(
      this.fieldValue<List<CommunityActivity>>(
          RecreationLogInputField.communityActivity),
    );

    if (communityActivities.contains(communityActivity)) {
      communityActivities.remove(communityActivity);
    } else {
      communityActivities.add(communityActivity);
    }

    this.updateField<List<CommunityActivity>>(
      RecreationLogInputField.communityActivity,
      value: communityActivities,
    );
  }

  void updateFamilyActivityField({
    FamilyActivity familyActivity,
    String validationMessage,
    String Function(List<FamilyActivity> value) validator,
  }) {
    final List<FamilyActivity> familyActivities = List.from(
      this.fieldValue<List<FamilyActivity>>(
          RecreationLogInputField.familyActivity),
    );

    if (familyActivities.contains(familyActivity)) {
      familyActivities.remove(familyActivity);
    } else {
      familyActivities.add(familyActivity);
    }

    this.updateField<List<FamilyActivity>>(
      RecreationLogInputField.familyActivity,
      value: familyActivities,
    );
  }
  // Future<bool> onWillPop() async {
  //   this.onBack();

  //   return false;
  // }

  void onBack() {
    final String logStorageKey = childLogStorageKey(
      child: this._child,
      date: this._date,
    );

    final RecreationLog currentLog = _keyValueStorageService.get<RecreationLog>(
      logStorageKey,
    );

    _navigationService.back<RecreationLog>(result: currentLog);
  }
}
