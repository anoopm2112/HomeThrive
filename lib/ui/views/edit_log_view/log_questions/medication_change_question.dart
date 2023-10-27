import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/edit_log_view/edit_log_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:stacked/stacked.dart';

class MedciationChangeQuestion extends ViewModelWidget<EditLogViewModel> {
  final bool medicationChange;
  final void Function(bool medicationChange) onChoiceSelected;
  final String initialComments;
  final void Function(String comments) onCommentsChanged;
  final String errorText;

  const MedciationChangeQuestion({
    Key key,
    this.medicationChange,
    this.onChoiceSelected,
    this.initialComments,
    this.onCommentsChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    EditLogViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    return Column(
      children: [
        TextColumn(
          headline: localization.medicationQuestion,
          subheadline: localization.selectOptionAndNote,
          error: this.errorText,
        ),
        SizedBox(height: 16),
        Row(
          // TODO
          children: [
            Expanded(
              child: SelectableButton<bool>.withLabel(
                label: localization.no,
                selected: !(this.medicationChange ?? true),
                value: false,
                onSelected: this.onChoiceSelected,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: SelectableButton<bool>.withLabel(
                label: localization.yes,
                selected: this.medicationChange ?? false,
                value: true,
                onSelected: this.onChoiceSelected,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        AppTextField(
          // TODO put into factory method
          keyboardType: TextInputType.text,
          minLines: 4,
          maxLines: null,
          scrollPadding: MediaQuery.of(context).viewInsets,
          contentPadding: EdgeInsets.all(16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          textCapitalization: TextCapitalization.sentences,
          initialText: this.initialComments,
          labelText: localization.comments,
          onChanged: this.onCommentsChanged,
          errorText: model.fieldValidationMessage(
            LogInputField.medicationChangeComments,
          ),
        ),
      ],
    );
  }
}
