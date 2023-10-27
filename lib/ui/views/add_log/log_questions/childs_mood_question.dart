import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/add_log/log_input/log_input_view_model.dart';
import 'package:fostershare/ui/views/add_log/mood_selection_row.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:stacked/stacked.dart';

class ChildsMoodQuestion extends ViewModelWidget<LogInputViewModel> {
  final MoodRating selectedMoodRating;
  final void Function(MoodRating mood) onMoodRatingSelected;
  final String initialComments;
  final void Function(String comments) onCommentsChanged;
  final String errorText;

  const ChildsMoodQuestion({
    Key key,
    this.selectedMoodRating,
    this.onMoodRatingSelected,
    this.initialComments,
    this.onCommentsChanged,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
    LogInputViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    return Column(
      children: [
        TextColumn(
          headline: localization.childMoodQuesion,
          subheadline: localization.selectOptionAndNote,
        ),
        SizedBox(height: 16),
        MoodSelectionRow(
          selectedMood: this.selectedMoodRating,
          onMoodRatingSelected: this.onMoodRatingSelected,
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
            LogInputField.childMoodComments,
          ),
        ),
      ],
    );
  }
}
