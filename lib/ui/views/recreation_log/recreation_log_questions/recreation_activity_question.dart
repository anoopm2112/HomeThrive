import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/ui/views/recreation_log/recreation_log_input/recreation_log_input_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:stacked/stacked.dart';

class RecreationActivityQuestion
    extends ViewModelWidget<RecreationLogInputViewModel> {
  final String initialComments;
  final void Function(String comments) onCommentsChanged;
  final String errorText;

  RecreationActivityQuestion({
    Key key,
    this.initialComments,
    this.onCommentsChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    RecreationLogInputViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    return Column(
      children: [
        TextColumn(
          headline: localization.recreationActivitySubQuestion,
          subheadline: localization.recreationActivityQuestion,
          error: this.errorText,
        ),
        SizedBox(height: 24),
        AppTextField(
          // TODO make into multiLine textfield widget
          keyboardType: TextInputType.text,
          minLines: 2,
          maxLines: null,
          scrollPadding: MediaQuery.of(context).viewInsets,
          contentPadding: EdgeInsets.all(16),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          textCapitalization: TextCapitalization.sentences,
          initialText: this.initialComments,
          labelText: localization.decribeActivities,
          onChanged: this.onCommentsChanged,
          errorText: model.fieldValidationMessage(
            RecreationLogInputField.reCreationActivityComments,
          ),
        ),
      ],
    );
  }
}
