import 'package:flutter/material.dart';

class EventDetailColumn extends StatelessWidget {
  final String label;
  final Widget child;

  const EventDetailColumn({
    Key key,
    @required this.label,
    @required this.child,
  })  : assert(label != null),
        assert(child != null),
        super(key: key);

  factory EventDetailColumn.text({
    @required String label,
    @required String headline,
    String body,
  }) = _EventDetailColumnWithTextContent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.label,
          style: textTheme.headline3.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textTheme.bodyText1.color,
          ),
        ),
        SizedBox(height: 4),
        this.child,
      ],
    );
  }
}

class _EventDetailColumnWithTextContent extends EventDetailColumn {
  _EventDetailColumnWithTextContent({
    @required String label,
    @required String headline,
    String body,
  })  : assert(label != null),
        assert(headline != null),
        super(
          label: label,
          child: Builder(
            builder: (context) {
              final theme = Theme.of(context);
              final textTheme = theme.textTheme;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline,
                    style: textTheme.headline1.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (body != null) ...[
                    SizedBox(height: 4),
                    Text(
                      body,
                      style: textTheme.bodyText1.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ]
                ],
              );
            },
          ),
        );
}
