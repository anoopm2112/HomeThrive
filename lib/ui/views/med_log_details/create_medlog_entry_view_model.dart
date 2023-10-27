import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/med_log_entry/failure_reason.dart';
import 'package:fostershare/core/models/data/med_log_note/med_log_note.dart';
import 'package:fostershare/core/models/input/med_log/create_med_log_note_input.dart';
import 'package:fostershare/core/models/input/med_log/get_medication_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/create_med_log_entry_input.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

enum CreateMedLogEntryInputField {
  dateTime,
  timeString,
  dateString,
  isSuccess,
  given,
  failReason,
  failDescription,
}

class CreateMedLogEntryViewModel extends BaseViewModel
    with FormViewModelMixin<CreateMedLogEntryInputField> {
  final _medLogsService = locator<MedLogService>();
  final _toastService = locator<ToastService>();
  final _navigationService = locator<NavigationService>();
  List<MedLogNote> notes = [];
  final String medLogId;
  final String medicationId;
  final int medLogYear;
  final int medLogMonth;

  CreateMedLogEntryViewModel(
    this.medLogId,
    this.medLogYear,
    this.medLogMonth,
    this.medicationId,
  )   : assert(medLogId != null),
        assert(medLogYear != null),
        assert(medLogMonth != null),
        assert(medicationId != null);

  Future<void> onModelReady() async {
    setBusy(true);
    await _initializeFields();
    setBusy(false);
  }

  setValue<T>(CreateMedLogEntryInputField field, T value) {
    updateField(field, value: value);
    notifyListeners();
  }

  setDate(DateTime date) {
    DateTime dateTime = fieldValue(CreateMedLogEntryInputField.dateTime);
    var newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      dateTime.hour,
      dateTime.minute,
    );
    setValue(CreateMedLogEntryInputField.dateTime, newDateTime);
    _setDateString();
    _setTimeString();
    notifyListeners();
  }

  setTime(TimeOfDay time) {
    DateTime dateTime = fieldValue(CreateMedLogEntryInputField.dateTime);
    var newDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      time.hour,
      time.minute,
    );
    setValue(CreateMedLogEntryInputField.dateTime, newDateTime);
    _setDateString();
    _setTimeString();
    notifyListeners();
  }

  String getFailureReasonString(FailureReason reason) {
    switch (reason) {
      case FailureReason.Refused:
        return "Refused";
        break;
      case FailureReason.Missed:
        return "Missed";
        break;
      case FailureReason.Error:
        return "Error";
        break;
    }
  }

  _getInitialDateTime() {
    var current = DateTime.now();
    if (current.year != medLogYear || current.month != medLogMonth) {
      return DateTime(medLogYear, medLogMonth, 1, current.hour, current.minute);
    }
    return current;
  }

  _setDateString() {
    var dateTime = fieldValue(CreateMedLogEntryInputField.dateTime);
    var dateString = DateFormat.yMMMMd().format(dateTime);
    setValue(CreateMedLogEntryInputField.dateString, dateString);
  }

  _setTimeString() {
    var dateTime = fieldValue(CreateMedLogEntryInputField.dateTime);
    var timeString = DateFormat.jm().format(dateTime);
    setValue(CreateMedLogEntryInputField.timeString, timeString);
  }

  createEntry() async {
    var validField = validateField(CreateMedLogEntryInputField.dateTime) &&
        validateField(CreateMedLogEntryInputField.timeString) &&
        validateField(CreateMedLogEntryInputField.dateString) &&
        validateField(CreateMedLogEntryInputField.isSuccess) &&
        validateField(CreateMedLogEntryInputField.given) &&
        validateField(CreateMedLogEntryInputField.failReason) &&
        validateField(CreateMedLogEntryInputField.failDescription);
    if (!validField) {
      notifyListeners();
      return;
    }
    setBusy(true);
    try {
      var medLogEntry = await _medLogsService.createNewEntry(
        CreateMedLogEntryInput(
            fieldValue(CreateMedLogEntryInputField.dateTime),
            fieldValue(CreateMedLogEntryInputField.timeString),
            fieldValue(CreateMedLogEntryInputField.dateString),
            fieldValue(CreateMedLogEntryInputField.isSuccess),
            fieldValue(CreateMedLogEntryInputField.given),
            fieldValue(CreateMedLogEntryInputField.failReason),
            fieldValue(CreateMedLogEntryInputField.failDescription),
            medLogId,
            medicationId),
      );
      _navigationService.back(result: medLogEntry);
    } catch (err) {
      _toastService.displayToast("Unable to create entry");
      setBusy(false);
    }
    notifyListeners();
    setBusy(false);
  }

  _initializeFields() {
    this.addAllFormFields({
      CreateMedLogEntryInputField.dateTime: FormFieldModel<DateTime>(
        value: _getInitialDateTime(),
        validator: (val) => (val == null) ? "Field should not be empty" : null,
      ),
      CreateMedLogEntryInputField.dateString: FormFieldModel<String>(
        value: null,
        validator: (val) => null,
      ),
      CreateMedLogEntryInputField.timeString: FormFieldModel<String>(
        value: null,
        validator: (val) => null,
      ),
      CreateMedLogEntryInputField.isSuccess: FormFieldModel<bool>(
        value: true,
        validator: (val) => (val == null) ? "Field should not be empty" : null,
      ),
      CreateMedLogEntryInputField.given: FormFieldModel<String>(
        value: null,
        validator: (val) =>
            fieldValue(CreateMedLogEntryInputField.isSuccess) != null &&
                    fieldValue(CreateMedLogEntryInputField.isSuccess) == true &&
                    (val == null || val.trim().isEmpty)
                ? "Field should not be empty"
                : null,
      ),
      CreateMedLogEntryInputField.failReason: FormFieldModel<FailureReason>(
        value: null,
        validator: (val) => fieldValue(CreateMedLogEntryInputField.isSuccess) !=
                    null &&
                fieldValue(CreateMedLogEntryInputField.isSuccess) == false &&
                (val == null)
            ? "Field should not be empty"
            : null,
      ),
      CreateMedLogEntryInputField.failDescription: FormFieldModel<String>(
        value: null,
        validator: (val) => fieldValue(CreateMedLogEntryInputField.isSuccess) !=
                    null &&
                fieldValue(CreateMedLogEntryInputField.isSuccess) == false &&
                (val == null || val.trim().isEmpty)
            ? "Field should not be empty"
            : null,
      ),
    });
    _setDateString();
    _setTimeString();
  }
}
