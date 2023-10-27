import 'package:fostershare/app/locator.dart';
import 'package:fostershare/core/models/data/child_log_note/child_log_note.dart';
import 'package:fostershare/core/models/input/create_child_log_note/create_child_log_note_input.dart';
import 'package:fostershare/core/services/children_service.dart';
import 'package:fostershare/core/services/logger_service.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/ui/common/forms/form_field_model.dart';
import 'package:fostershare/ui/common/forms/form_view_model_mixin.dart';
import 'package:meta/meta.dart';
import 'package:stacked/stacked.dart';

enum AddNoteField {
  notes,
}

class AddNoteViewModel extends BaseViewModel
    with FormViewModelMixin<AddNoteField> {
  final _childrenService = locator<ChildrenService>();
  final _loggerService = locator<LoggerService>();
  final _navigationService = locator<NavigationService>();
  final AppLocalizations localization;

  final String _childLogId;

  AddNoteViewModel({
    this.localization,
    @required String childLogId,
  })  : assert(childLogId != null),
        this._childLogId = childLogId {
    this.addAllFormFields(
      {
        AddNoteField.notes: FormFieldModel<String>(
          validator: (note) => note == null || note.trim().isEmpty
              ? localization.enterNotesAbove
              : null,
        ),
      },
    );
  }

  @override
  void updateField<T>(
    AddNoteField key, {
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

  void onClose() {
    _loggerService.info("AddNoteViewModel - onClose()");

    _navigationService.back();
  }

  Future<void> onSaveNote() async {
    _loggerService.info("AddNoteViewModel - onSaveNote()");

    final bool validForm = this.validateForm();
    notifyListeners();

    if (validForm) {
      this.setBusy(true);

      try {
        final ChildLogNote note = await _childrenService.createChildLogNote(
          CreateChildLogNoteInput(
            childLogId: this._childLogId,
            text: this.fieldValue<String>(AddNoteField.notes),
          ),
        );

        _navigationService.back<ChildLogNote>(result: note);
      } catch (e, s) {
        _loggerService.error(
          "AddNoteViewModel - onSaveNote() - couldn't create child log note",
          error: e,
          stackTrace: s,
        );

        this.setError("There was an error saving the note. Please try again.");
      }
    }
  }
}
