import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fostershare/core/models/data/enums/enums.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/common/date_format_utils.dart';
import 'package:fostershare/ui/common/svg_asset_images.dart';
import 'package:fostershare/ui/common/ui_utils.dart';

class MyChildrenLogRow extends StatelessWidget {
  final DateTime date;
  final MoodRating moodRating;
  final void Function() onTap;

  const MyChildrenLogRow({
    Key key,
    @required this.date,
    @required this.moodRating,
    this.onTap,
  })  : assert(date != null),
        assert(moodRating != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        padding: defaultViewChildPaddingHorizontal,
        decoration: BoxDecoration(
          color: theme.dialogBackgroundColor,
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFD8D8D8), // TODO
            ),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              svgImageFromMoodRating(moodRating),
              width: 24,
              height: 24, // TODO dynamic
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                formattedyMMMd(date),
                style: theme.textTheme.bodyText2,
              ),
            ),
            Icon(
              AppIcons.chevronRight,
              color: Color(0xFF95A1AC), // TODO
            ),
          ],
        ),
      ),
    );
  }
}
