import 'package:flutter/material.dart';

class CardTextColumn extends StatelessWidget {
  final String title;
  final double verticalSpace;
  final String description;
  final Color titleColor;

  const CardTextColumn({
    Key key,
    @required this.title,
    this.verticalSpace = 10,
    this.titleColor,
    @required this.description,
  })  : assert(title != null),
        assert(description != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.title,
          style: textTheme.headline3
              .copyWith(fontSize: 16)
              .copyWith(color: titleColor),
        ),
        SizedBox(height: this.verticalSpace),
        Text(
          this.description,
          style: textTheme.bodyText2,
        ),
      ],
    );
  }
}
