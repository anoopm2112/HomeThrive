import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/circle_painter.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/widgets/user_avatar.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

enum ChildLogStatus {
  today,
  upcoming,
  select,
  missing,
  incomplete,
  submitted,
}

class ChildLogCard extends StatelessWidget {
  final void Function() onCardCreated;
  final void Function() onTap;
  final ImageProvider<Object> image;
  final String name;
  final String description;
  final ChildLogStatus status;

  const ChildLogCard({
    Key key,
    this.onTap,
    this.onCardCreated,
    @required this.image,
    @required this.name,
    @required this.description,
    this.status = ChildLogStatus.missing,
  })  : assert(image != null),
        assert(name != null),
        assert(description != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool select = this.status == ChildLogStatus.select;
    final bool complete = this.status == ChildLogStatus.submitted;
    final bool missing = this.status == ChildLogStatus.missing;
    final bool incomplete = this.status == ChildLogStatus.incomplete;
    final bool today = this.status == ChildLogStatus.today;
    final bool upcoming = this.status == ChildLogStatus.upcoming;
    final localization = AppLocalizations.of(context);

    return CreationAwareWidget(
      onWidgetCreated: this.onCardCreated,
      child: GestureDetector(
        onTap: this.onTap,
        child: Card(
          color: this.status == ChildLogStatus.submitted
              ? Color(0xFFDBE2E7)
              : null,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // CustomPaint(
                //   painter: CirclePainter(
                //     color: Color(0x999AC7DD), // TODO theme color
                //     radius: 5,
                //   ),
                // ),
                //SizedBox(width: 16),
                // UserAvatar(
                //   image: this.image,
                // ),
                Image.asset(
                  PngAssetImages.dailyLog,
                  width: 62.0,
                  height: 62.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CardTextColumn(
                    title: this.name,
                    description: this.description,
                    verticalSpace: 2,
                  ),
                ),
                if (!select)
                  Text(
                    _childLogStatusToText(localization), // TODO
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 12,
                          color: (complete || upcoming || today)
                              ? Color(0xFF8ABAD3)
                              : missing
                                  ? Color(0xFFE75365)
                                  : Color(0xFFE47837),
                        ),
                  ),
                SizedBox(width: 8),
                if (select)
                  Text(localization.hi)
                else
                  Icon(
                    complete ? Icons.check : AppIcons.chevronRight,
                    color: (complete || upcoming || today)
                        ? Color(0xFF8ABAD3)
                        : missing
                            ? Color(0xFFE75365)
                            : Color(0xFFE47837),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _childLogStatusToText(AppLocalizations localization) {
    switch (this.status) {
      case ChildLogStatus.missing:
        return localization.missing;
      case ChildLogStatus.today:
        return localization.today;
      case ChildLogStatus.upcoming:
        return localization.upcoming;
      case ChildLogStatus.incomplete:
        return localization.incomplete;
      default:
        return localization.complete;
    }
  }
}
