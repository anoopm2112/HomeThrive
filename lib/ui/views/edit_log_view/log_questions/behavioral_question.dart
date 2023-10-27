import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/string_utils.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/edit_log_view/edit_log_view_model.dart';
import 'package:fostershare/ui/widgets/app_text_field.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:fostershare/ui/widgets/text_column.dart';
import 'package:stacked/stacked.dart';

class BehavioralQuestion extends ViewModelWidget<EditLogViewModel> {
  final bool behaviorlIssues;
  final List<ChildBehavior> selectedBehaviors;
  final void Function(bool behavioralIssues) onHasBehavioralIssuesSelected;
  final void Function(ChildBehavior) onBehaviorSelected;
  final String initialComments;
  final void Function(String comments) onCommentsChanged;
  final String errorText;

  BehavioralQuestion({
    Key key,
    this.behaviorlIssues,
    this.selectedBehaviors,
    this.onHasBehavioralIssuesSelected,
    this.onBehaviorSelected,
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
          headline: localization.behaviorQuestion,
          subheadline: localization.behaviorSubQuestion,
          error: this.errorText,
        ),
        SizedBox(height: 24),
        Row(
          // TODO put into widget
          children: [
            Expanded(
              child: SelectableButton<bool>.withLabel(
                label: localization.no,
                selected: !(this.behaviorlIssues ?? true),
                value: false,
                onSelected: this.onHasBehavioralIssuesSelected,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: SelectableButton<bool>.withLabel(
                label: localization.yes,
                selected: this.behaviorlIssues ?? false,
                value: true,
                onSelected: this.onHasBehavioralIssuesSelected,
              ),
            ),
          ],
        ),
        AnimatedCrossFade(
          // TODO look into
          crossFadeState: (this.behaviorlIssues ?? false)
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
              SizedBox(height: 10),
              Text(
                "What happened?",
                style: Theme.of(context).textTheme.headline1.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: getResponsiveMediumFontSize(
                        context,
                      ),
                    ),
              ),
              SizedBox(height: 14),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  itemCount: ChildBehavior.values.length,
                  separatorBuilder: (context, index) => SizedBox(width: 8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final ChildBehavior behavior = ChildBehavior.values[index];
                    return SelectableButton<ChildBehavior>(
                      value: behavior,
                      selected: this.selectedBehaviors?.contains(
                                behavior,
                              ) ??
                          false,
                      onSelected: this.onBehaviorSelected,
                      width: 80,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 6,
                          top: 8,
                          right: 6,
                          bottom: 12,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              svgImageFromChildBehavior(behavior),
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(height: 6),
                            Text(
                              _behaviorLabelFromChildBehavior(
                                behavior,
                                localization,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: getResponsiveFontSize(
                                  context,
                                  fontSize: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 14),
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
                labelText: "Describe the situation in a few words…",
                onChanged: this.onCommentsChanged,
                errorText: model.fieldValidationMessage(
                  LogInputField.behavioralComments,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _behaviorLabelFromChildBehavior(
      ChildBehavior behavior, AppLocalizations localizations) {
    switch (behavior) {
      case ChildBehavior.agression:
        return localizations.aggression;
      case ChildBehavior.anxiety:
        return localizations.anxiety;
      case ChildBehavior.bedWetting:
        return localizations.bedWetting;
      case ChildBehavior.depression:
        return localizations.depression;
      case ChildBehavior.food:
        return localizations.foodIssues;
      case ChildBehavior.schoolIssues:
        return localizations.schoolIssues;
      case ChildBehavior.other:
        return localizations.other;
      default:
        return "";
    }
  }
}
