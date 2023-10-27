import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/views/add_log/log_input/log_input_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:stacked/stacked.dart';

class BioFamilyVisitQuestion extends ViewModelWidget<LogInputViewModel> {
  final bool bioFamilyVisit;
  final void Function(bool bioFamilyVisit) onChoiceSelected;
  final String initialComments;
  final void Function(String comments) onCommentsChanged;
  final String errorText;

  const BioFamilyVisitQuestion({
    Key key,
    this.bioFamilyVisit,
    this.onChoiceSelected,
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
          headline: localization.bioFamQuestion, // TODO
          subheadline: localization.bioFamSubQuestion,
          error: this.errorText,
        ),
        SizedBox(height: 24),
        Row(
          // TODO
          children: [
            Expanded(
              child: SelectableButton<bool>.withLabel(
                selected: this.bioFamilyVisit == false,
                label: localization.no,
                value: false,
                onSelected: this.onChoiceSelected,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: SelectableButton<bool>.withLabel(
                selected: this.bioFamilyVisit == true,
                label: localization.yes,
                value: true,
                onSelected: this.onChoiceSelected,
              ),
            ),
          ],
        ),
        AnimatedCrossFade(
          // TODO look into
          crossFadeState: (this.bioFamilyVisit ?? false)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 400),
          firstChild: SizedBox(
            width: double.infinity,
          ),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30),
              Text(
                localization.whatHappened,
                style: Theme.of(context).textTheme.headline1.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: getResponsiveMediumFontSize(
                        context,
                      ),
                    ),
              ),
              SizedBox(height: 20),
              AppTextField(
                // TODO
                keyboardType: TextInputType.text,
                minLines: 4,
                maxLines: null,
                scrollPadding: MediaQuery.of(context).viewInsets,
                contentPadding: EdgeInsets.all(16),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                textCapitalization: TextCapitalization.sentences,
                initialText: this.initialComments,
                labelText: localization.describeVisit,
                onChanged: this.onCommentsChanged,
                errorText: model.fieldValidationMessage(
                  LogInputField.bioFamilyVisitComments,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
