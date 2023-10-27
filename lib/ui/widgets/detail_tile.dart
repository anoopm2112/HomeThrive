import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailTile extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final Widget trailing;
  final VoidCallback trailingAction;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool small;
  DetailTile({
    this.title = "",
    this.value = "",
    this.description,
    this.onTap,
    this.trailing,
    this.trailingAction,
    this.onLongPress,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.all(small ? 8 : 14),
        decoration: BoxDecoration(
          color: theme.dialogBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.15),
              blurRadius: 3,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: textTheme.headline3.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textTheme.bodyText1.color,
                      ),
                    ),
                  SizedBox(height: 4),
                  Text(
                    value ?? "",
                    style: textTheme.headline1.copyWith(
                      fontSize: small ? 16 : 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (description != null) ...[
                    SizedBox(height: small ? 0 : 4),
                    Text(
                      description,
                      style: textTheme.bodyText1.copyWith(
                        color: theme.primaryColor,
                        fontSize: small ? 12 : null,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            if (trailing != null)
              GestureDetector(
                onTap: trailingAction,
                child: trailing,
              ),
          ],
        ),
      ),
    );
  }
}
