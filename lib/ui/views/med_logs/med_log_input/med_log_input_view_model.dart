import 'dart:math';
import 'package:fostershare/core/models/data/med_log/child_sex_enum.dart';
import 'package:fostershare/core/models/data/med_log_entry/med_log_entry.dart';
import 'package:fostershare/core/models/input/med_log/create_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log/create_med_log_note_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/create_med_log_entry_input.dart';
import 'package:fostershare/core/models/input/medlog_medication_details/create_medication_details_input.dart';
import 'package:fostershare/core/models/type/current_user.dart';
import 'package:fostershare/core/services/auth/auth_service.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/med_log_entry/failure_reason.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/services/key_value_storage/key_value_storage_service.dart';
import 'package:fostershare/core/services/key_value_storage/utils.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

enum MedLogInputState {
  selectMedication,
  missedMedicine,
  selectMissedMedication,
  missedMedicationReason,
  medicationEntry,
  medLogSubmit,
  newMedication,
  medLogEntryDetails
}
enum CreateMedicationInputField {
  name,
  reason,
  dosage,
  strength,
  physicianName,
  prescriptionDate,
  prescriptionDateString,
  notes,
  hasEarlierDate,
  dateTime,
  timeString,
  dateString,
  isSuccess,
  isMedicationMissed,
  given,
  failReason,
  failDescription,
  medLogId,
  medicationId,
  medications
}

class MedLogInputViewModel extends BaseViewModel
    with FormViewModelMixin<CreateMedicationInputField> {
  final _medLogsService = locator<MedLogService>();
  final _keyValueStorageService = locator<KeyValueStorageService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final _toastService = locator<ToastService>();
  final _authService = locator<AuthService>();
  final AppLocalizations localization;
  final String _submitting = "SigningInKey";
  bool get submitting => this.busy(this._submitting);

  MedLogInputState _state = MedLogInputState.selectMedication;
  MedLogInputState get state => _state;

  int get activeIndex => min(
        this._state.index,
        MedLogInputState.values.length - 2,
      );

  DateTime _date;
  Child _child;
  Child get child => _child;
  PickedFile _imageFile;
  String get selectedImageFileName =>
      this._imageFile != null ? basename(this._imageFile.path) : null;
  List<MedLogMedicationDetail> medicationList;
  String _medLogId;
  List<MedLogMedicationDetail> selectedMedicationList;
  MedLogMedicationDetail activeMedication;
  int medicationIndex = 0;
  CurrentUser get _currentUser => _authService.currentUser;
  String get parentName => _currentUser?.fullName;
  bool get checkMedication =>
      (this.selectedMedicationList.length - 1 <= this.medicationIndex) ?? false;

  bool chkVvalue = false;
  bool noneAdministered = false;

  MedLog _medLog;
  MedLog get medLog => _medLog;
  final Map<String, List<MedLogEntry>> entries = <String, List<MedLogEntry>>{};
  List entryKeys = [];
  void Function(MedLog medLog) _onMedLogChanged;
  MedLogInputViewModel({
    @required this.localization,
    @required DateTime date,
    @required Child child,
    MedLog medLog,
    void Function(MedLog medLog) onComplete,
  })  : assert(date != null),
        assert(child != null),
        this._date = date,
        this._child = child,
        this._medLogId = medLog?.id,
        this._medLog = medLog ?? null,
        this.medicationList = medLog != null ? medLog.medications : [],
        this._onMedLogChanged = onComplete {
    final String logStorageKey = childLogStorageKey(
      child: this._child,
      date: this._date,
    );
    if (medLog != null &&
        (medLog.entries != null && medLog.entries.isNotEmpty)) {
      var todaysEntry =
          medLog.entries.where((element) => isSameDay(element.dateTime, date));
      _insertmedLogEntry(medLog.entries);
      if (todaysEntry != null && todaysEntry.isNotEmpty) {
        this._state = MedLogInputState.medLogEntryDetails;
      }
    }

    // MedLog initialMedLog = MedLog();

    // final bool incompleteLog = _keyValueStorageService.containsKey(
    //   logStorageKey,
    // );
    // if (incompleteLog) {
    //   initialMedLog = _keyValueStorageService.get<MedLog>(
    //     logStorageKey,
    //   );
    // }
    this.addAllFormFields(
      {
        CreateMedicationInputField.name: FormFieldModel<String>(
          value: null,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.fieldNotBeEmpty
              : null,
        ),
        CreateMedicationInputField.strength: FormFieldModel<String>(
          value: null,
          validator: (val) => null,
        ),
        CreateMedicationInputField.dosage: FormFieldModel<String>(
          value: null,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.fieldNotBeEmpty
              : null,
        ),
        CreateMedicationInputField.reason: FormFieldModel<String>(
          value: null,
          validator: (val) => (val == null || val.trim().isEmpty)
              ? localization.fieldNotBeEmpty
              : null,
        ),
        CreateMedicationInputField.notes: FormFieldModel<String>(
          value: null,
          validator: (val) => null,
        ),
        CreateMedicationInputField.physicianName: FormFieldModel<String>(
          value: null,
          validator: (val) => null,
        ),
        CreateMedicationInputField.prescriptionDate: FormFieldModel<DateTime>(
          value: DateTime.now(),
          validator: (val) => null,
        ),
        CreateMedicationInputField.prescriptionDateString:
            FormFieldModel<String>(
          value: DateFormat.yMMMMd().format(DateTime.now()),
          validator: (val) => null,
        ),
        CreateMedicationInputField.hasEarlierDate: FormFieldModel<bool>(
          value: false,
          validator: (val) => val == null ? localization.selectOption : null,
        ),
        CreateMedicationInputField.dateTime: FormFieldModel<DateTime>(
          value: _date ?? DateTime.now(),
          validator: (val) => null,
        ),
        CreateMedicationInputField.dateString: FormFieldModel<String>(
          value: _date != null
              ? DateFormat.yMMMMd().format(_date)
              : DateFormat.yMMMMd().format(DateTime.now()),
          validator: (val) => null,
        ),
        CreateMedicationInputField.timeString: FormFieldModel<String>(
          value: _date != null
              ? DateFormat.jm().format(_date)
              : DateFormat.jm().format(DateTime.now()),
          validator: (val) => null,
        ),
        CreateMedicationInputField.medications:
            FormFieldModel<List<MedLogMedicationDetail>>(
          value: [],
          validator: (val) =>
              (val.isEmpty) ? localization.selectAlteastOne : null,
        ),
        CreateMedicationInputField.isMedicationMissed: FormFieldModel<bool>(
          value: true,
          validator: (val) => val == null ? localization.selectOption : null,
        ),
        CreateMedicationInputField.isSuccess: FormFieldModel<bool>(
          value: false,
          validator: (val) => null,
        ),
        CreateMedicationInputField.failReason: FormFieldModel<FailureReason>(
          value: FailureReason.Refused,
          validator: (val) =>
              (val == null) ? localization.selectAlteastOne : null,
        ),
        CreateMedicationInputField.failDescription: FormFieldModel<String>(
          value: null,
          validator: (val) =>
              (val == null) ? localization.fieldNotBeEmpty : null,
        ),
        CreateMedicationInputField.medicationId: FormFieldModel<String>(
          value: null,
          validator: (val) => null,
        ),
        CreateMedicationInputField.given: FormFieldModel<String>(
          value: "-",
          validator: (val) => null,
        ),
      },
    );
    // if (this.field(CreateMedicationInputField.name).validate().valid) {
    //   this._state = MedLogInputState.selectMedication;
    // }
  }
  @override
  void updateField<T>(
    CreateMedicationInputField key, {
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
// String fieldValidationMessage(K key) {
//     assert(_formFields.containsKey(key));

//     return _formFields[key].validationMessage;
//   }
  void updateMedicationField({
    MedLogMedicationDetail medication,
    String validationMessage,
    String Function(List value) validator,
  }) {
    if (noneAdministered && _state != MedLogInputState.selectMissedMedication) {
      notifyListeners();
      return;
    }
    final List<MedLogMedicationDetail> medications = List.from(
      this.fieldValue<List<MedLogMedicationDetail>>(
          CreateMedicationInputField.medications),
    );

    if (medications.contains(medication)) {
      medications.remove(medication);
    } else {
      medications.add(medication);
    }

    this.updateField<List<MedLogMedicationDetail>>(
      CreateMedicationInputField.medications,
      value: medications,
    );
    notifyListeners();
  }

  void updateNonAdminsteredField() {
    noneAdministered = !noneAdministered;
    this.updateField<List<MedLogMedicationDetail>>(
      CreateMedicationInputField.medications,
      value: [],
    );
    notifyListeners();
  }

  void onPrevious() {
    // TODO made it programtic you can't mess up
    if (_state == MedLogInputState.selectMedication) {
      _state = MedLogInputState.selectMedication;
    } else if (_state == MedLogInputState.medicationEntry) {
      this.updateMedicationField(
        medication: null,
      );
      _state = MedLogInputState.selectMedication;
    } else if (_state == MedLogInputState.medLogSubmit) {
      if (noneAdministered && activeMedication != null) {
        _state = MedLogInputState.missedMedicationReason;
      } else if (noneAdministered && activeMedication == null) {
        _state = MedLogInputState.missedMedicine;
      } else
        _state = MedLogInputState.medicationEntry;
      chkVvalue = false;
    } else if (_state == MedLogInputState.missedMedicine) {
      noneAdministered = false;
      selectedMedicationList = [];
      activeMedication = null;
      this.updateMedicationField(
        medication: activeMedication,
      );
      _state = MedLogInputState.selectMedication;
    } else if (_state == MedLogInputState.missedMedicationReason) {
      selectedMedicationList = [];
      activeMedication = null;
      this.updateMedicationField(
        medication: activeMedication,
      );
      _state = MedLogInputState.missedMedicine;
    } else {
      _state = MedLogInputState.values[_state.index - 1];
    }
    notifyListeners();
  }

  void onNewMedClose() {
    _state = MedLogInputState.selectMedication;
    notifyListeners();
  }

  void onImageSelected(PickedFile file) {
    _imageFile = file;
  }

  void createMedication() {
    _state = MedLogInputState.newMedication;
    notifyListeners();
  }

  setValue<T>(CreateMedicationInputField field, T value) {
    updateField(field, value: value);
    notifyListeners();
  }

  onMedLogChecked(bool chk) {
    chkVvalue = chk;
    notifyListeners();
  }

  Future<void> onNext() async {
    bool canContinue = false;
    switch (_state) {
      case MedLogInputState.selectMedication:
        canContinue =
            (this.validateField(CreateMedicationInputField.medications) ||
                noneAdministered);
        if (!canContinue)
          _toastService.displayToast(localization.selectAlteastOne);
        break;
      case MedLogInputState.selectMissedMedication:
        canContinue =
            this.validateField(CreateMedicationInputField.medications);
        if (!canContinue)
          _toastService.displayToast(localization.selectAlteastOne);
        break;
      case MedLogInputState.missedMedicationReason:
        canContinue =
            (this.validateField(CreateMedicationInputField.failReason) &&
                this.validateField(CreateMedicationInputField.failDescription));
        break;
      case MedLogInputState.missedMedicine:
        canContinue = true;
        // this.validateField(CreateMedicationInputField.reCreationActivityComments) &&
        //     this.validateField(CreateMedicationInputField.reCreationActivityComments);
        break;
      case MedLogInputState.medicationEntry:
        setValue(CreateMedicationInputField.isSuccess, true);
        // canContinue = this.validateField(MedLogInputField.dayRating) &&
        //     this.validateField(MedLogInputField.dayRatingComments);
        canContinue = true;
        break;
      case MedLogInputState.medLogSubmit:
        canContinue = chkVvalue;
        if (!canContinue) _toastService.displayToast(localization.checkTheBox);
        break;
      default:
        break;
    }

    if (canContinue) {
      if (this._state != MedLogInputState.medLogSubmit) {
        if (this._state == MedLogInputState.selectMedication) {
          this.selectedMedicationList =
              fieldValue(CreateMedicationInputField.medications) ?? [];
          if (this.selectedMedicationList.isNotEmpty) {
            this.selectedMedicationList.removeWhere((value) => value == null);
            activeMedication = this.selectedMedicationList[0];
            setValue(
                CreateMedicationInputField.medicationId, activeMedication.id);
            _state = MedLogInputState.medicationEntry;
          } else if (noneAdministered) {
            _state = MedLogInputState.missedMedicine;
          }
        } else if (this._state == MedLogInputState.selectMissedMedication) {
          this.selectedMedicationList =
              fieldValue(CreateMedicationInputField.medications) ?? [];
          if (this.selectedMedicationList.isNotEmpty) {
            activeMedication = this.selectedMedicationList[0];
            setValue(
                CreateMedicationInputField.medicationId, activeMedication.id);
            _state = MedLogInputState.missedMedicationReason;
          } else if (noneAdministered) {
            _state = MedLogInputState.missedMedicine;
          }
        } else if (this._state == MedLogInputState.medicationEntry ||
            this._state == MedLogInputState.missedMedicationReason) {
          _state = MedLogInputState.medLogSubmit;
        } else if (this._state == MedLogInputState.missedMedicine) {
          if (!this.fieldValue(
            CreateMedicationInputField.isMedicationMissed,
          )) {
            setValue(CreateMedicationInputField.failDescription, " ");
            setValue(CreateMedicationInputField.reason, "");
            _state = MedLogInputState.medLogSubmit;
          } else {
            _state = MedLogInputState.selectMissedMedication;
          }
        } else
          _state = MedLogInputState.values[_state.index + 1];
      } else {
        if (_medLogId == null || _medLogId.isEmpty) {
          await createMedlog(null);
        }
        createEntry();
      }
    }

    notifyListeners();
  }

  //
  // Future<bool> onWillPop() async {
  //   this.onBack();

  //   return false;
  // }

  void onBack() {
    _navigationService.back();
  }

  String getFailureReasonString(FailureReason reason) {
    switch (reason) {
      case FailureReason.Refused:
        return localization.childRefused;
        break;
      case FailureReason.Missed:
        return localization.missedWindow;
        break;
      case FailureReason.Error:
        return localization.other;
        break;
    }
  }

  Future<bool> onWillPop() async {
    _navigationService.back<MedLog>(result: this._medLog);
    return false;
  }

  createEntry() async {
    setBusy(true);
    try {
      var medLogEntry = await _medLogsService.createNewEntry(
        CreateMedLogEntryInput(
          fieldValue(CreateMedicationInputField.dateTime),
          fieldValue(CreateMedicationInputField.timeString),
          fieldValue(CreateMedicationInputField.dateString),
          fieldValue(CreateMedicationInputField.isSuccess),
          fieldValue(CreateMedicationInputField.given),
          fieldValue(CreateMedicationInputField.failReason),
          fieldValue(CreateMedicationInputField.failDescription),
          _medLogId,
          fieldValue(CreateMedicationInputField.medicationId),
        ),
      );
      _toastService.displayToast(localization.submitSuccess);
      if (_medLog.entries != null)
        _medLog.entries.add(medLogEntry);
      else
        _medLog.entries = <MedLogEntry>[medLogEntry];

      if (this.checkMedication) {
        this._onMedLogChanged?.call(_medLog);
        // _navigationService.back();
      } else {
        this.medicationIndex += 1;
        activeMedication = this.selectedMedicationList[this.medicationIndex];
        setValue(CreateMedicationInputField.medicationId, activeMedication.id);
        if (noneAdministered) {
          _state = MedLogInputState.missedMedicationReason;
          setValue(CreateMedicationInputField.failDescription, "");
        } else
          _state = MedLogInputState.medicationEntry;
      }
      chkVvalue = false;
      notifyListeners();
    } catch (err) {
      _toastService.displayToast(localization.unableToCreate);
      setBusy(false);
      return;
    }
    notifyListeners();
    setBusy(false);
  }

  void newMedication() async {
    if (this.validateField(CreateMedicationInputField.name) &&
        //this.validateField(CreateMedicationInputField.strength) &&
        this.validateField(CreateMedicationInputField.dosage) &&
        this.validateField(CreateMedicationInputField.reason)) {
      setBusy(true);
      var medicationsInput = CreateMedicationDetailsInput(
        fieldValue(CreateMedicationInputField.name),
        fieldValue(CreateMedicationInputField.reason),
        fieldValue(CreateMedicationInputField.dosage),
        fieldValue(CreateMedicationInputField.strength),
        physicianName: fieldValue(CreateMedicationInputField.physicianName),
        prescriptionDate:
            fieldValue(CreateMedicationInputField.prescriptionDate),
        prescriptionDateString:
            fieldValue(CreateMedicationInputField.prescriptionDateString),
      );
      var notes = CreateMedLogNoteInput(
          fieldValue(CreateMedicationInputField.notes), _medLogId);
      try {
        if (_medLogId != null && _medLogId.isNotEmpty) {
          var result = await _medLogsService
              .addNewMedications(_medLogId, [medicationsInput]);
          if (result != null) {
            medicationList = result;

            var entryId = result.first.id;
            if (fieldValue(CreateMedicationInputField.notes).trim() != null) {
              await _medLogsService.addNewNotesForMedication(_medLogId, [
                CreateMedLogNoteInput(
                  fieldValue(CreateMedicationInputField.notes).trim(),
                  result.first.id,
                )
              ]);
            }
          }
        } else {
          await createMedlog(medicationsInput);
        }
      } catch (err) {
        _toastService.displayToast(localization.unableToCreate);
      }

      setBusy(false);
      _state = MedLogInputState.selectMedication;
    }
    notifyListeners();
  }

  createMedlog(CreateMedicationDetailsInput medicationsInput) async {
    var createMedLogInput = CreateMedLogInput(
      ChildSex.Male,
      _date.year,
      _date.month,
      _child.id,
      medications: medicationsInput != null ? [medicationsInput] : null,
    );
    var medLog = await _medLogsService.createMedLog(createMedLogInput);
    medicationList = medLog?.medications;
    _medLogId = medLog?.id;
    _medLog = medLog;
    notifyListeners();
  }

  addMoreMedication() {
    _state = MedLogInputState.selectMedication;
    notifyListeners();
  }

  setDate(DateTime date) {
    DateTime dateTime = fieldValue(CreateMedicationInputField.dateTime);
    var newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      dateTime.hour,
      dateTime.minute,
    );
    setValue(CreateMedicationInputField.dateTime, newDateTime);
    _setDateString();
    _setTimeString();
    notifyListeners();
  }

  setTime(TimeOfDay time) {
    DateTime dateTime = fieldValue(CreateMedicationInputField.dateTime);
    var newDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      time.hour,
      time.minute,
    );
    setValue(CreateMedicationInputField.dateTime, newDateTime);
    _setDateString();
    _setTimeString();
    notifyListeners();
  }

  _setDateString() {
    var dateTime = fieldValue(CreateMedicationInputField.dateTime);
    var dateString = DateFormat.yMMMMd().format(dateTime);
    setValue(CreateMedicationInputField.dateString, dateString);
  }

  _setTimeString() {
    var dateTime = fieldValue(CreateMedicationInputField.dateTime);
    var timeString = DateFormat.jm().format(dateTime);
    setValue(CreateMedicationInputField.timeString, timeString);
  }

  _insertmedLogEntry(entry) {
    entry.forEach((entry) {
      var date = DateTime(
          entry.dateTime.year, entry.dateTime.month, entry.dateTime.day);
      final String medLogKey = date.toLocal().toString();
      if (entries.containsKey(medLogKey)) {
        entries[medLogKey].add(entry);
      } else {
        entries[medLogKey] = <MedLogEntry>[entry];
      }
      if (entryKeys.where((element) => element == medLogKey).isEmpty)
        entryKeys.add(medLogKey);
    });
  }
}
