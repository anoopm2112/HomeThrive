import 'package:flutter/cupertino.dart';
import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/med_log_note/med_log_note.dart';
import 'package:fostershare/core/models/input/med_log/create_med_log_note_input.dart';
import 'package:fostershare/core/models/input/med_log/get_medication_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/create_med_log_entry_note_input.dart';
import 'package:fostershare/core/models/input/med_log_entry/get_med_log_entry_input.dart';
import 'package:fostershare/core/services/med_log_service.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/toast_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:stacked/stacked.dart';

enum CreateMedLogNoteInputField {
  content,
}

class CreateMedLogNoteViewModel extends BaseViewModel
    with FormViewModelMixin<CreateMedLogNoteInputField> {
  final _medLogsService = locator<MedLogService>();
  final _toastService = locator<ToastService>();
  final _navigationService = locator<NavigationService>();
  List<MedLogNote> notes = [];
  final String medLogId;
  final String medicationId;
  final String medLogEntryId;

  CreateMedLogNoteViewModel(
    this.medLogId, {
    this.medicationId,
    this.medLogEntryId,
  });

  Future<void> onModelReady() async {
    setBusy(true);
    await _initializeFields();
    await _retrieveExistingNotes();
    setBusy(false);
  }

  setValue<T>(CreateMedLogNoteInputField field, T value) {
    updateField(field, value: value);
    notifyListeners();
  }

  back() {
    _navigationService.back(result: notes.length);
  }

  createNote() async {
    setBusy(true);
    if (!validateField(CreateMedLogNoteInputField.content)) {
      notifyListeners();
      return;
    }
    try {
      if (medLogEntryId != null && medicationId == null) {
        await _medLogsService.addNewNotesForEntry(medLogId, medLogEntryId, [
          CreateMedLogEntryNoteInput(
            fieldValue(CreateMedLogNoteInputField.content).trim(),
          )
        ]);
      } else if (medicationId != null && medLogEntryId == null) {
        await _medLogsService.addNewNotesForMedication(medLogId, [
          CreateMedLogNoteInput(
            fieldValue(CreateMedLogNoteInputField.content).trim(),
            medicationId,
          )
        ]);
      }
    } catch (err) {
      _toastService.displayToast("Unable to create note");
      setBusy(false);
      throw err;
    }
    await _retrieveExistingNotes();
    notifyListeners();
    setBusy(false);
  }

  _retrieveExistingNotes() async {
    try {
      if (medLogEntryId != null && medicationId == null) {
        await _getMedLogEntryNotes();
      } else if (medicationId != null && medLogEntryId == null) {
        await _getMedicationNotes();
      }
    } catch (err) {
      _toastService.displayToast("Unable to load notes");
    }
  }

  _getMedLogEntryNotes() async {
    var res =
        await _medLogsService.medLogEntry(GetMedLogEntryInput(medLogEntryId));
    notes = res.notes;
  }

  _getMedicationNotes() async {
    var res = await _medLogsService.medLogMedication(
      GetMedicationInput(medicationId),
    );
    notes = res.notes;
  }

  _initializeFields() {
    this.addAllFormFields({
      CreateMedLogNoteInputField.content: FormFieldModel<String>(
        value: null,
        validator: (val) => (val == null || val.trim().isEmpty)
            ? "Field should not be empty"
            : null,
      ),
    });
  }
}
