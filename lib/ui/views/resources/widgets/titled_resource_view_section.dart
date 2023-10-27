import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';
import 'package:fostershare/ui/common/ui_utils.dart';

class TitledResourceViewSection extends StatelessWidget {
  final String title;
  final Widget child;

  const TitledResourceViewSection({
    Key key,
    @required this.title,
    this.child,
  })  : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: defaultViewPaddingHorizontal.add(
            EdgeInsets.symmetric(
              horizontal: 1.5,
            ),
          ),
          child: Text(
            this.title,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: getResponsiveSmallFontSize(context),
                ),
          ),
        ),
        SizedBox(height: 10),
        if (child != null) this.child,
      ],
    );
  }
}
