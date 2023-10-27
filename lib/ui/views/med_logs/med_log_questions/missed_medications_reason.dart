import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/med_log_entry/failure_reason.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/med_logs/med_log_input/med_log_input_view_model.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:stacked/stacked.dart';

class MissedMedicationReason extends ViewModelWidget<MedLogInputViewModel> {
  final FailureReason failureReason;
  final String failureDescription;
  final void Function(FailureReason reason) onReasonSelected;
  final void Function(String desc) onDescriptionChanged;
  final String errorText;

  MissedMedicationReason({
    Key key,
    this.failureReason,
    this.failureDescription,
    this.onReasonSelected,
    this.onDescriptionChanged,
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
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextColumn(
                headline: localization.whyWasntAdministered,
                subheadline: "",
                error: this.errorText,
              ),
              Center(
                child: Text(
                    "${model.activeMedication.medicationName + ', ' + model.activeMedication.dosage}"),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: FailureReason.values
                    .map(
                      (x) => SelectableButton<FailureReason>(
                        selected: x == this.failureReason,
                        value: x,
                        onSelected: this.onReasonSelected,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 8,
                          ),
                          child: Text(
                            model.getFailureReasonString(x),
                            style:
                                Theme.of(context).textTheme.headline3.copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: getResponsiveSmallFontSize(
                                        context,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (!model.validateField(CreateMedicationInputField.failReason))
                Text(
                  model.fieldValidationMessage(
                      CreateMedicationInputField.failReason),
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              Text(localization.whatHappened +
                  " (" +
                  localization.required +
                  ")"),
              SizedBox(height: 8),
              AppTextField(
                minLines: 2,
                maxLines: null,
                initialText: model
                    .fieldValue(CreateMedicationInputField.failDescription),
                scrollPadding: MediaQuery.of(context).viewInsets,
                contentPadding: EdgeInsets.all(16),
                labelText: localization.comments,
                textInputAction: TextInputAction.next,
                onChanged: this.onDescriptionChanged,
                errorText: model.fieldValidationMessage(
                  CreateMedicationInputField.failDescription,
                ),
              )
            ])
      ],
    );
  }
}
