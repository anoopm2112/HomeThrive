import 'package:flutter/cupertino.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child/child.dart';
import 'package:fostershare/core/models/data/med_log/child_sex_enum.dart';
import 'package:fostershare/core/models/data/med_log/med_log.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:fostershare/core/models/input/cursor_pagination_input/cursor_pagination_input.dart';
import 'package:fostershare/core/models/input/med_log/create_med_log_input.dart';
import 'package:fostershare/core/models/input/med_log/get_med_logs_input.dart';
import 'package:fostershare/core/models/input/med_log/med_log_date_input.dart';
import 'package:fostershare/core/models/input/medlog_medication_details/create_medication_details_input.dart';
import 'package:fostershare/core/models/response/med_log/get_med_logs_response.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:stacked/stacked.dart';

enum CreateMedLogInputField {
  child,
  month,
  year,
  sex,
  allergies,
  medications,
}

class CreateMedLogViewModel extends BaseViewModel
    with FormViewModelMixin<CreateMedLogInputField> {
  final _medLogsService = locator<MedLogService>();
  final _childrenService = locator<ChildrenService>();
  final _toastService = locator<ToastService>();
  final _navigationService = locator<NavigationService>();

  int _limit = 10000000;
  GetMedLogsResponse _getMedLogsResponse;
  int get totalCount => _getMedLogsResponse.pageInfo.count;
  List<MedLog> _existingLogs = [];
  List<MedLog> availableLogsToCreate = [];
  List<Child> _children = [];
  MedLogDateInput _fd; //To cache the calculated from date
  MedLogDateInput _td; //To cache the calculated to date
  DateTime _ct; //To cache value of current time
  List<MedLogMedicationDetail> suggestedMedications;
  MedLog _previousMedLog;
  bool isReviewMode = false;

  setReviewMode(bool isReviewMode) {
    this.isReviewMode = isReviewMode;
    notifyListeners();
  }

  MedLogDateInput get _fromDate {
    if (_fd != null) {
      return _fd;
    }
    var currentDate = _currentTime;
    var fromDate = DateTime(
        currentDate.year, currentDate.month - 1); // Load from previous month
    _fd = MedLogDateInput(fromDate.year, fromDate.month);
    return _fd;
  }

  MedLogDateInput get _toDate {
    if (_td != null) {
      return _td;
    }
    var currentDate = _currentTime;
    _td = MedLogDateInput(currentDate.year, currentDate.month);
    return _td;
  }

  DateTime get _currentTime {
    if (_ct != null) {
      return _ct;
    }
    _ct = DateTime.now();
    return _ct;
  }

  VoidCallback getOnTapReview() {
    var hasError = validateField(CreateMedLogInputField.child) &&
        validateField(CreateMedLogInputField.month) &&
        validateField(CreateMedLogInputField.year) &&
        validateField(CreateMedLogInputField.sex) &&
        validateField(CreateMedLogInputField.allergies) &&
        validateField(CreateMedLogInputField.medications);
    if (!hasError) {
      return null;
    } else {
      return () => {setReviewMode(true)};
    }
  }

  List<MedLogDateInput> get _datesRange {
    var fromDate = _fromDate;
    var toDate = _toDate;
    List<MedLogDateInput> range = [];
    var _iDate = DateTime(fromDate.year, fromDate.month);
    while (true) {
      range.add(MedLogDateInput(_iDate.year, _iDate.month));
      _iDate = DateTime(_iDate.year, _iDate.month + 1);
      if (_iDate.year > _toDate.year || _iDate.month > _toDate.month) {
        break;
      }
    }
    return range;
  }

  Future<void> onModelReady() async {
    setBusy(true);
    _initializeFields();
    await _loadMedLogs();
    var datesRange = _datesRange;
    for (var i in datesRange) {
      for (var j in _children) {
        var exists = _existingLogs.any((element) =>
            element.child.id == j.id &&
            element.year == i.year &&
            element.month == i.month);
        if (!exists) {
          availableLogsToCreate.add(
            MedLog(
              month: i.month,
              year: i.year,
              child: Child(
                id: j.id,
                imageURL: j.imageURL,
                firstName: j.firstName,
                lastName: j.lastName,
              ),
            ),
          );
        }
      }
    }
    setBusy(false);
  }

  selectLogForCreation(MedLog log) async {
    updateField(CreateMedLogInputField.child, value: log.child);
    updateField(CreateMedLogInputField.year, value: log.year);
    updateField(CreateMedLogInputField.month, value: log.month);
    setBusy(true);
    await _loadPreviousMedLog();
    if (_previousMedLog != null) {
      updateField(CreateMedLogInputField.sex, value: _previousMedLog.childSex);
      updateField(CreateMedLogInputField.allergies,
          value: _previousMedLog.allergies);
      var previousMonth = DateTime(_currentTime.year, _currentTime.month - 1);
      if (_previousMedLog.year == previousMonth.year &&
          _previousMedLog.month == previousMonth.month) {
        suggestedMedications = _previousMedLog.medications;
      }
    }
    notifyListeners();
    setBusy(false);
  }

  setValue<T>(CreateMedLogInputField field, T value) {
    updateField(field, value: value);
    notifyListeners();
  }

  String getChildSexString(ChildSex sex) {
    var strings = {
      // TODO: Localize
      ChildSex.Male: "Male",
      ChildSex.Female: "Female",
      ChildSex.Other: "Other"
    };
    return strings[sex];
  }

  List<String> getChildSexStringList() {
    return ChildSex.values.map((e) => getChildSexString(e)).toList();
  }

  _loadPreviousMedLog() async {
    try {
      var res = await _medLogsService.medLogs(
        GetMedLogsInput(
          CursorPaginationInput(
            limit: 1,
          ),
          childId: fieldValue(CreateMedLogInputField.child).id,
        ),
        extendedDetails: true,
      );
      _previousMedLog = res.items.isEmpty ? null : res.items[0];
    } catch (err) {
      print(err); //TODO: Handle error
    }
  }

  addMedicationSuggestion(MedLogMedicationDetail medication) {
    if (suggestedMedications == null || suggestedMedications.isEmpty) {
      suggestedMedications = [medication];
    } else {
      suggestedMedications.add(medication);
    }
    notifyListeners();
  }

  createMedLog() async {
    setBusy(true);
    var allergies = fieldValue(CreateMedLogInputField.allergies);
    if (allergies != null && allergies.trim().isEmpty) {
      allergies = null;
    }
    List<MedLogMedicationDetail> medications =
        fieldValue(CreateMedLogInputField.medications) ?? [];
    var medicationsInput = medications
        .map((x) => CreateMedicationDetailsInput(
            x.medicationName, x.reason, x.dosage, x.strength,
            physicianName: x.physicianName,
            prescriptionDate: x.prescriptionDate,
            prescriptionDateString: x.prescriptionDateString))
        .toList();
    var createMedLogInput = CreateMedLogInput(
      fieldValue(CreateMedLogInputField.sex),
      fieldValue(CreateMedLogInputField.year),
      fieldValue(CreateMedLogInputField.month),
      fieldValue(CreateMedLogInputField.child).id,
      allergies: allergies,
      medications: medicationsInput,
    );
    try {
      var medLog = await _medLogsService.createMedLog(createMedLogInput);
      _navigationService.back<MedLog>(result: medLog);
    } catch (err) {
      _toastService.displayToast("Unable to create log");
    }
    setBusy(false);
  }

  _loadMedLogs() async {
    try {
      _children = await _childrenService.children();
      _getMedLogsResponse = await _medLogsService.medLogs(
        GetMedLogsInput(
          CursorPaginationInput(
            limit: _limit,
            cursor: _getMedLogsResponse?.pageInfo?.cursor,
          ),
          fromDate: _fromDate,
          toDate: _toDate,
        ),
      );
    } catch (err) {
      print(err); //TODO: Handle error
    }
    _existingLogs.addAll(_getMedLogsResponse.items);
  }

  _initializeFields() {
    this.addAllFormFields({
      CreateMedLogInputField.child: FormFieldModel<Child>(
        value: null,
        validator: (child) => null,
      ),
      CreateMedLogInputField.month: FormFieldModel<int>(
        value: null,
        validator: (month) => null,
      ),
      CreateMedLogInputField.year: FormFieldModel<int>(
        value: null,
        validator: (year) => null,
      ),
      CreateMedLogInputField.sex: FormFieldModel<ChildSex>(
        value: null,
        validator: (sex) => sex == null ? "Select child sex" : null,
      ),
      CreateMedLogInputField.allergies: FormFieldModel<String>(
        value: null,
        validator: (allergies) => null,
      ),
      CreateMedLogInputField.medications:
          FormFieldModel<List<MedLogMedicationDetail>>(
        value: null,
        validator: (medications) => null,
      ),
    });
  }
}
