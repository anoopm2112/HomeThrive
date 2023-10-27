import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/ui/views/med_logs/med_log_input/med_log_input_view_model.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:stacked/stacked.dart';

class MissedMedications extends ViewModelWidget<MedLogInputViewModel> {
  final bool isSuccess;
  final void Function(bool success) onMedicationSuccessSelected;
  final String errorText;

  MissedMedications({
    Key key,
    this.isSuccess,
    this.onMedicationSuccessSelected,
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
        TextColumn(
          headline: localization.wereAnyMedMissed,
          subheadline: "",
          error: this.errorText,
        ),
        SizedBox(height: 24),
        Row(
          // TODO put into widget
          children: [
            Expanded(
              child: SelectableButton<bool>.withLabel(
                label: localization.yes,
                selected: this.isSuccess ?? false,
                value: true,
                onSelected: this.onMedicationSuccessSelected,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: SelectableButton<bool>.withLabel(
                label: localization.no,
                selected: !(this.isSuccess ?? true),
                value: false,
                onSelected: this.onMedicationSuccessSelected,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
