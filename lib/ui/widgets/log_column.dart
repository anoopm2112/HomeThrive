import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/string_utils.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/ui/views/log_summary/log_question_summary.dart';
import 'package:fostershare/ui/widgets/selectable_button.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

// TODO take in childlog as a parameter
class LogColumn extends StatelessWidget {
  final MoodRating dayRating;
  final String dayRatingComments;
  final VoidCallback onTapDayRating;
  final MoodRating parentMoodRating;
  final String parentMoodComments;
  final VoidCallback onTapParentMood;
  final List<ChildBehavior> behavioral;
  final String behavioralComments;
  final VoidCallback onTapBehavioral;
  final bool familyVisit;
  final String familyVisitComments;
  final VoidCallback onTapFamilyVisit;
  final MoodRating childMoodRating;
  final String childMoodComments;
  final VoidCallback onTapChildMood;
  final bool medicationChange;
  final String medicationChangeComments;
  final VoidCallback onTapMedicationChange;
  final bool endBorder;

  const LogColumn({
    Key key,
    this.dayRating,
    this.dayRatingComments,
    this.onTapDayRating,
    this.parentMoodRating,
    this.parentMoodComments,
    this.onTapParentMood,
    this.behavioral,
    this.behavioralComments,
    this.onTapBehavioral,
    this.familyVisit,
    this.familyVisitComments,
    this.onTapFamilyVisit,
    this.childMoodRating,
    this.childMoodComments,
    this.onTapChildMood,
    this.medicationChange,
    this.medicationChangeComments,
    this.onTapMedicationChange,
    this.endBorder = false,
  })  : assert(endBorder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool behavioralIssues = this.behavioral?.isNotEmpty ?? false;
    final localization = AppLocalizations.of(context);

    return Column(
      children: [
        GestureDetector(
          onTap: onTapDayRating,
          child: LogQuestionSummary(
            question: localization.dayRatingQuestion,
            answer: this.dayRating == null
                ? null
                : SvgPicture.asset(
                    svgImageFromMoodRating(this.dayRating),
                  ),
            comments: this.dayRatingComments,
            bottomBorder: true,
          ),
        ),
        GestureDetector(
          onTap: onTapParentMood,
          child: LogQuestionSummary(
            question: localization.howDoYouFeel,
            answer: this.parentMoodRating == null
                ? null
                : SvgPicture.asset(
                    svgImageFromMoodRating(this.parentMoodRating),
                  ),
            comments: this.parentMoodComments,
            bottomBorder: true,
          ),
        ),
        GestureDetector(
          onTap: onTapBehavioral,
          child: LogQuestionSummary.textAnswer(
            question: localization.behaviorQuestion,
            answer: !behavioralIssues
                ? this.parentMoodRating == null || this.familyVisit == null
                    ? null
                    : localization.no
                : behavioralIssues
                    ? localization.yes
                    : localization.no,
            center: this.behavioral == null || this.behavioral.isEmpty
                ? null
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: this
                        .behavioral
                        .map<Widget>(
                          (behavior) => SelectableButton(
                            selected: true,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    svgImageFromChildBehavior(behavior),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    _behaviorLabelFromChildBehavior(
                                      behavior,
                                      localization,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        .copyWith(
                                          fontWeight: FontWeight.w300,
                                          fontSize: getResponsiveSmallFontSize(
                                            context,
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
            comments: this.behavioralComments,
            bottomBorder: true,
          ),
        ),
        GestureDetector(
          onTap: onTapFamilyVisit,
          child: LogQuestionSummary.textAnswer(
            question: localization.bioFamQuestion,
            answer: this.familyVisit == null
                ? null
                : this.familyVisit
                    ? localization.yes
                    : localization.no,
            comments: this.familyVisitComments,
            bottomBorder: true,
          ),
        ),
        GestureDetector(
          onTap: onTapChildMood,
          child: LogQuestionSummary(
            question: localization.childMoodQuesion,
            answer: this.childMoodRating == null
                ? null
                : SvgPicture.asset(
                    svgImageFromMoodRating(this.childMoodRating),
                  ),
            comments: this.childMoodComments,
            bottomBorder: true,
          ),
        ),
        GestureDetector(
          onTap: onTapMedicationChange,
          child: LogQuestionSummary.textAnswer(
            question: localization.medicationQuestion,
            answer: this.medicationChange == null
                ? null // TODO util function
                : this.medicationChange
                    ? localization.yes
                    : localization.no,
            comments: this.medicationChangeComments,
            bottomBorder: this.endBorder,
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
