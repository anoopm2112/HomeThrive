import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';

class TextColumn extends StatelessWidget {
  final String headline;
  final String subheadline;
  final String error;

  const TextColumn({
    Key key,
    @required this.headline,
    @required this.subheadline,
    this.error,
  })  : assert(headline != null),
        assert(subheadline != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bool hasErrorText = this.error?.trim()?.isNotEmpty ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          this.headline.trim(),
          style: textTheme.headline1.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: getResponsiveLargeFontSize(
              context,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          this.subheadline.trim(),
          style: textTheme.bodyText2.copyWith(
            fontSize: getResponsiveSmallFontSize(
              context,
            ),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: AnimatedCrossFade(
            crossFadeState: hasErrorText
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 400),
            firstChild: Text(
              hasErrorText ? this.error : "",
              style: textTheme.bodyText1.copyWith(
                  color: theme.errorColor,
                  fontSize: getResponsiveSmallFontSize(context)),
            ),
            secondChild: SizedBox(),
          ),
        ),
      ],
    );
  }
}
