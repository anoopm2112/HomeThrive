import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/cards/child_log_card.dart';
import 'package:fostershare/ui/widgets/circle_painter.dart';
import 'package:fostershare/ui/widgets/user_avatar.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

class ChildLogRow extends StatelessWidget {
  final ImageProvider<Object> image;
  final String name;
  final String description;
  final ChildLogStatus status;
  final bool showTrail;

  const ChildLogRow({
    Key key,
    @required this.image,
    @required this.name,
    @required this.description,
    this.status = ChildLogStatus.missing, // TODO look into
    this.showTrail = true,
  })  : assert(image != null),
        assert(name != null),
        assert(description != null),
        assert(showTrail != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool select = this.status == ChildLogStatus.select;
    final bool complete = this.status == ChildLogStatus.submitted;
    final bool missing = this.status == ChildLogStatus.missing;
    final bool incomplete =
        this.status == ChildLogStatus.incomplete; // TODO need?
    final localization = AppLocalizations.of(context);

    return Row(
      children: [
        CustomPaint(
          painter: CirclePainter(
            color: Color(0x999AC7DD), // TODO theme color
            radius: 5,
            offset: Offset(5, 0),
          ),
        ),
        SizedBox(width: 22),
        UserAvatar(
          image: this.image,
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
                  color: complete
                      ? Color(0xFF8ABAD3)
                      : missing
                          ? Color(0xFFE75365)
                          : Color(0xFFE47837),
                ),
          ),
        SizedBox(width: 8),
        if (showTrail)
          Icon(
            complete ? Icons.check : AppIcons.chevronRight, // TODO
            color: complete
                ? Color(0xFF8ABAD3)
                : missing
                    ? Color(0xFFE75365)
                    : Color(0xFFE47837),
          ),
      ],
    );
  }

  String _childLogStatusToText(AppLocalizations localization) {
    // TODO
    switch (this.status) {
      case ChildLogStatus.missing:
        return localization.missing;
      case ChildLogStatus.incomplete:
        return localization.incomplete;
      default:
        return localization.complete;
    }
  }
}
