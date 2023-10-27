import 'package:flutter/cupertino.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/medlog_medication_detail/medlog_medication_detail.dart';
import 'package:fostershare/core/models/input/medlog_medication_details/create_medication_details_input.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

enum CreateMedicationInputField {
  name,
  reason,
  dosage,
  strength,
  physicianName,
  prescriptionDate,
  prescriptionDateString,
}

class CreateMedicationViewModel extends BaseViewModel
    with FormViewModelMixin<CreateMedicationInputField> {
  final _medLogsService = locator<MedLogService>();
  final _toastService = locator<ToastService>();
  final _navigationService = locator<NavigationService>();
  final String medLogId;

  CreateMedicationViewModel(this.medLogId);

  bool isValidInput() {
    var isValid = validateField(CreateMedicationInputField.name) &&
        validateField(CreateMedicationInputField.strength) &&
        validateField(CreateMedicationInputField.reason) &&
        validateField(CreateMedicationInputField.dosage) &&
        validateField(CreateMedicationInputField.prescriptionDate) &&
        validateField(CreateMedicationInputField.prescriptionDateString) &&
        validateField(CreateMedicationInputField.physicianName);
    return isValid;
  }

  Future<void> onModelReady() async {
    setBusy(true);
    _initializeFields();
    setBusy(false);
  }

  setValue<T>(CreateMedicationInputField field, T value) {
    updateField(field, value: value);
    notifyListeners();
  }

  updatePrescriptionDate(DateTime date) {
    setValue(CreateMedicationInputField.prescriptionDate, date);
    if (date == null) {
      setValue(CreateMedicationInputField.prescriptionDateString, null);
    } else {
      var dateString = DateFormat.yMMMMd().format(date);
      setValue(CreateMedicationInputField.prescriptionDateString, dateString);
    }
  }

  createMedication() async {
    if (!isValidInput()) {
      notifyListeners();
      return;
    }
    setBusy(true);
    List<MedLogMedicationDetail> newMedLogs;
    // try {
    //   var result = await _medLogsService.addNewMedications(medLogId, [
    //     CreateMedicationDetailsInput(
    //       fieldValue(CreateMedicationInputField.name),
    //       fieldValue(CreateMedicationInputField.reason),
    //       fieldValue(CreateMedicationInputField.dosage),
    //       fieldValue(CreateMedicationInputField.strength),
    //       physicianName: fieldValue(CreateMedicationInputField.physicianName),
    //       prescriptionDate:
    //           fieldValue(CreateMedicationInputField.prescriptionDate),
    //       prescriptionDateString:
    //           fieldValue(CreateMedicationInputField.prescriptionDateString),
    //     )
    //   ]);
    //   newMedLogs = result;
    // } catch (err) {
    //   _toastService.displayToast("Unable to create medication");
    // }
    if (newMedLogs != null) {
      _navigationService.back(result: newMedLogs);
    }
    setBusy(false);
  }

  _initializeFields() {
    this.addAllFormFields({
      CreateMedicationInputField.name: FormFieldModel<String>(
        value: null,
        validator: (val) => (val == null || val.trim().isEmpty)
            ? "Field should not be empty"
            : null,
      ),
      CreateMedicationInputField.strength: FormFieldModel<String>(
        value: null,
        validator: (val) => (val == null || val.trim().isEmpty)
            ? "Field should not be empty"
            : null,
      ),
      CreateMedicationInputField.dosage: FormFieldModel<String>(
        value: null,
        validator: (val) => (val == null || val.trim().isEmpty)
            ? "Field should not be empty"
            : null,
      ),
      CreateMedicationInputField.reason: FormFieldModel<String>(
        value: null,
        validator: (val) => (val == null || val.trim().isEmpty)
            ? "Field should not be empty"
            : null,
      ),
      CreateMedicationInputField.physicianName: FormFieldModel<String>(
        value: null,
        validator: (val) => null,
      ),
      CreateMedicationInputField.prescriptionDate: FormFieldModel<DateTime>(
        value: null,
        validator: (val) => null,
      ),
      CreateMedicationInputField.prescriptionDateString: FormFieldModel<String>(
        value: null,
        validator: (val) => null,
      ),
    });
  }
}
