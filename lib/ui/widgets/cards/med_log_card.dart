import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/circle_painter.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/widgets/user_avatar.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

enum MedLogCardType {
  complete,
  notSubmitted,
  notSigned,
  signPending,
  submitted,
  empty,
  create,
  today,
  upcoming
}

class MedLogCard extends StatelessWidget {
  final void Function() onCardCreated;
  final void Function() onTap;
  final ImageProvider<Object> image;
  final String name;
  final String description;
  final bool isSubmitted;
  final bool isSigned;
  final bool canSign;
  final bool isCreate;
  final bool signPending;
  final DateTime date;
  final bool dailyLogSubmitted;
  MedLogCardType _type;

  MedLogCard({
    Key key,
    this.onTap,
    this.onCardCreated,
    @required this.image,
    @required this.name,
    @required this.description,
    this.isSubmitted,
    this.isSigned,
    this.signPending,
    this.canSign,
    this.isCreate,
    this.date,
    this.dailyLogSubmitted = false,
  }) : super(key: key) {
    assert(image != null);
    assert(name != null);
    assert(description != null);

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    if (dailyLogSubmitted) {
      _type = MedLogCardType.submitted;
    } else if (date != null && today.compareTo(date) == 0) {
      _type = MedLogCardType.today;
    } else if (date != null && date.isAfter(today)) {
      _type = MedLogCardType.upcoming;
    } else if (isCreate != null && isCreate) {
      _type = MedLogCardType.create;
    } else if (isSubmitted == null || isSigned == null || canSign == null) {
      _type = MedLogCardType.empty;
    } else if (isSubmitted && signPending && canSign) {
      _type = MedLogCardType.signPending;
    } else if (isSubmitted && !isSigned && canSign) {
      _type = MedLogCardType.notSigned;
    } else if (isSubmitted && !isSigned && !canSign) {
      _type = MedLogCardType.submitted;
    } else if (isSubmitted && isSigned) {
      _type = MedLogCardType.complete;
    } else if (!isSubmitted) {
      _type = MedLogCardType.notSubmitted;
    } else {
      _type = MedLogCardType.empty;
    }
  }
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return CreationAwareWidget(
      onWidgetCreated: this.onCardCreated,
      child: GestureDetector(
        onTap: this.onTap,
        child: Card(
          color: _getCardColor(_type),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // CustomPaint(
                //   painter: CirclePainter(
                //     color: Color(0xFFFFEA00), // TODO theme color
                //     radius: 7,
                //   ),
                // ),
                // SizedBox(width: 16),
                // UserAvatar(
                //   image: this.image,
                // ),
                Image.asset(
                  PngAssetImages.medLog,
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
                Text(
                  _medLogStatusToText(localization, _type), // TODO
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 12,
                        color: _getTextColor(_type),
                      ),
                ),
                SizedBox(width: 8),
                Icon(
                  _getIcon(_type),
                  color: _getTextColor(_type),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCardColor(MedLogCardType type) {
    switch (type) {
      case MedLogCardType.complete:
        return Color(0xFFDBE2E7);
        break;
      case MedLogCardType.notSubmitted:
        return null;
        break;
      case MedLogCardType.notSigned:
        return null;
        break;
      case MedLogCardType.signPending:
        return null;
        break;
      case MedLogCardType.submitted:
        return null;
        break;
      case MedLogCardType.empty:
        return null;
        break;
      case MedLogCardType.create:
        return null;
        break;
      case MedLogCardType.today:
        return null;
        break;
      case MedLogCardType.upcoming:
        return null;
        break;
    }
    return null;
  }

  Color _getTextColor(MedLogCardType type) {
    switch (type) {
      case MedLogCardType.complete:
        return Color(0xFF8ABAD3);
        break;
      case MedLogCardType.notSubmitted:
        return Color(0xFFE47837);
        break;
      case MedLogCardType.notSigned:
        return Color(0xFFE75365);
        break;
      case MedLogCardType.signPending:
        return Color(0xFFE75365);
        break;
      case MedLogCardType.submitted:
        return Color(0xFF8ABAD3);
        break;
      case MedLogCardType.empty:
        return Color(0xFFE75365);
        break;
      case MedLogCardType.create:
        return Color(0xFFE75365);
        break;
      case MedLogCardType.today:
        return Color(0xFF8ABAD3);
        break;
      case MedLogCardType.upcoming:
        return Color(0xFF8ABAD3);
        break;
    }
    return null;
  }

  IconData _getIcon(MedLogCardType type) {
    switch (type) {
      case MedLogCardType.complete:
        return Icons.check;
        break;
      case MedLogCardType.notSubmitted:
        return AppIcons.chevronRight;
        break;
      case MedLogCardType.notSigned:
        return AppIcons.chevronRight;
        break;
      case MedLogCardType.signPending:
        return AppIcons.chevronRight;
        break;
      case MedLogCardType.submitted:
        return Icons.check;
        break;
      case MedLogCardType.empty:
        return null;
        break;
      case MedLogCardType.create:
        return AppIcons.chevronRight;
        break;
      case MedLogCardType.today:
        return AppIcons.chevronRight;
        break;
      case MedLogCardType.upcoming:
        return AppIcons.chevronRight;
        break;
    }
    return null;
  }

  String _medLogStatusToText(
      AppLocalizations localization, MedLogCardType type) {
    switch (type) {
      case MedLogCardType.complete:
        return localization.complete;
        break;
      case MedLogCardType.notSubmitted:
        return localization.notSubmitted;
        //return "Not Submitted"; //TODO:Localization localization.notSubmitted;
        break;
      case MedLogCardType.notSigned:
        return localization
            .notSigned; //TODO:Localization localization.notSigned;
        break;
      case MedLogCardType.signPending:
        return localization
            .signingInprogress; //TODO:Localization localization.notSigned;
        break;
      case MedLogCardType.submitted:
        return localization
            .submitted; //TODO:Localization localization.submitted;
        break;
      case MedLogCardType.empty:
        return localization.missing;
        break;
      case MedLogCardType.create:
        return localization.missing;
        break;
      case MedLogCardType.today:
        return localization.today;
        break;
      case MedLogCardType.upcoming:
        return localization.upcoming;
        break;
    }
    return null;
  }
}
