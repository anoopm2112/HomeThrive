import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/ui/views/med_logs/med_log_input/med_log_input_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:stacked/stacked.dart';

class CreateMedication extends ViewModelWidget<MedLogInputViewModel> {
  final String medName;
  final String dosage;
  final String reason;
  final String physicianName;
  final String notes;
  final void Function(String name) onMedNameChanged;
  final void Function(String dosage) onDosageChanged;
  final void Function(String strngth) onStrengthChanged;
  final void Function(String reason) onReasonChanged;
  final void Function(String physician) onPhysicianNameChanged;
  final void Function(String notes) onNotesChanged;
  final String errorText;

  CreateMedication({
    Key key,
    this.medName,
    this.dosage,
    this.reason,
    this.physicianName,
    this.notes,
    this.onMedNameChanged,
    this.onDosageChanged,
    this.onStrengthChanged,
    this.onReasonChanged,
    this.onPhysicianNameChanged,
    this.onNotesChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    MedLogInputViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localization.nameOfMedication),
        SizedBox(height: 5),
        AppTextField(
          keyboardType: TextInputType.text,
          maxLines: null,
          scrollPadding: MediaQuery.of(context).viewInsets,
          contentPadding: EdgeInsets.all(16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          textCapitalization: TextCapitalization.sentences,
          labelText: "",
          onChanged: this.onMedNameChanged,
          textInputAction: TextInputAction.next,
          errorText: model.fieldValidationMessage(
            CreateMedicationInputField.name,
          ),
        ),
        SizedBox(height: 10),
        Text(localization.dosage),
        SizedBox(height: 5),
        AppTextField(
          scrollPadding: MediaQuery.of(context).viewInsets,
          contentPadding: EdgeInsets.all(16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          textCapitalization: TextCapitalization.sentences,
          labelText: "",
          onChanged: this.onDosageChanged,
          textInputAction: TextInputAction.next,
          // keyboardType: TextInputType.number,
          errorText: model.fieldValidationMessage(
            CreateMedicationInputField.dosage,
          ),
        ),
        SizedBox(height: 10),
        Text(localization.strength),
        SizedBox(height: 5),
        AppTextField(
          scrollPadding: MediaQuery.of(context).viewInsets,
          contentPadding: EdgeInsets.all(16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          textCapitalization: TextCapitalization.sentences,
          labelText: "",
          onChanged: this.onStrengthChanged,
          textInputAction: TextInputAction.next,
          errorText: model.fieldValidationMessage(
            CreateMedicationInputField.strength,
          ),
        ),
        SizedBox(height: 10),
        Text(localization.purpose),
        SizedBox(height: 5),
        AppTextField(
          scrollPadding: MediaQuery.of(context).viewInsets,
          contentPadding: EdgeInsets.all(16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          textCapitalization: TextCapitalization.sentences,
          labelText: "",
          onChanged: this.onReasonChanged,
          textInputAction: TextInputAction.next,
          errorText: model.fieldValidationMessage(
            CreateMedicationInputField.reason,
          ),
        ),
        SizedBox(height: 10),
        Text(localization.prescribingDoctor +
            " (" +
            localization.ifApplicable +
            ")"),
        SizedBox(height: 5),
        AppTextField(
          scrollPadding: MediaQuery.of(context).viewInsets,
          contentPadding: EdgeInsets.all(16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          textCapitalization: TextCapitalization.sentences,
          labelText: "",
          onChanged: this.onPhysicianNameChanged,
          textInputAction: TextInputAction.next,
          errorText: model.fieldValidationMessage(
            CreateMedicationInputField.physicianName,
          ),
        ),
        SizedBox(height: 10),
        Text(localization.medicationNotes),
        SizedBox(height: 5),
        AppTextField(
          scrollPadding: MediaQuery.of(context).viewInsets,
          contentPadding: EdgeInsets.all(16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          textCapitalization: TextCapitalization.sentences,
          labelText: "",
          onChanged: this.onNotesChanged,
          textInputAction: TextInputAction.done,
          errorText: model.fieldValidationMessage(
            CreateMedicationInputField.notes,
          ),
        ),
      ],
    );
  }
}
