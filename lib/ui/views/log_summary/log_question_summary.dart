import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

class LogQuestionSummary extends StatelessWidget {
  final String question;
  final Widget answer;
  final Widget center;
  final String comments;
  final bool bottomBorder;
  final bool rightChervon;

  const LogQuestionSummary({
    Key key,
    @required this.question,
    this.answer,
    this.comments,
    this.center,
    this.bottomBorder = false,
    this.rightChervon = false,
  })  : assert(question != null),
        assert(bottomBorder != null),
        assert(rightChervon != null),
        super(key: key);

  factory LogQuestionSummary.textAnswer({
    Key key,
    @required String question,
    String answer,
    Widget center,
    String comments,
    bool bottomBorder,
    bool rightChevron,
  }) = _LogQuestionSummaryTextAnswer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: this.bottomBorder
            ? Border(
                bottom: BorderSide(
                  color: Color(0xFFE6E6E6),
                ),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  this.question.trim(),
                  style: textTheme.headline3.copyWith(
                    fontWeight: FontWeight.w100,
                    fontSize: getResponsiveMediumFontSize(context),
                  ),
                ),
              ),
              if (this.answer != null) ...[
                SizedBox(width: 8),
                this.answer,
              ],
              SizedBox(width: 12),
              if (this.rightChervon)
                Icon(
                  AppIcons.chevronRight,
                ),
            ],
          ),
          if (this.center != null)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 10,
              ),
              child: center,
            ),
          // TODO function?
          if (this.comments?.trim()?.isNotEmpty ?? false)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    localization.comments,
                    style: textTheme.headline3.copyWith(
                      fontSize: getResponsiveSmallFontSize(context),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    this.comments.trim(),
                    style: textTheme.bodyText1.copyWith(
                      fontSize: getResponsiveSmallFontSize(context),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LogQuestionSummaryTextAnswer extends LogQuestionSummary {
  _LogQuestionSummaryTextAnswer({
    Key key,
    @required String question,
    String answer,
    Widget center,
    String comments,
    bool bottomBorder = false,
    bool rightChevron = true,
  })  : assert(question != null),
        assert(bottomBorder != null),
        assert(rightChevron != null),
        super(
          key: key,
          question: question,
          answer: answer == null
              ? null
              : Builder(
                  builder: (context) {
                    final theme = Theme.of(context);
                    return Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF1D334B), // from themeTODO
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        answer.trim(),
                        style: theme.textTheme.headline3.copyWith(
                          color: theme.dialogBackgroundColor,
                          fontSize: getResponsiveMediumFontSize(context),
                        ),
                      ),
                    );
                  },
                ),
          center: center,
          comments: comments,
          bottomBorder: bottomBorder,
        );
}
