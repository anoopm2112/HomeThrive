import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/circle_painter.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/widgets/user_avatar.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

class EventCard extends StatelessWidget {
  final void Function() onTap;
  final ImageProvider<Object> image;
  final String title;
  final String description;

  EventCard({
    Key key,
    this.onTap,
    this.image,
    @required this.title,
    @required this.description,
  }) : super(key: key) {
    assert(title != null);
    assert(description != null);
  }
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return CreationAwareWidget(
      child: GestureDetector(
        onTap: this.onTap,
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Image.asset(
                  this.image ?? PngAssetImages.events,
                  width: 62.0,
                  height: 62.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CardTextColumn(
                    title: this.title,
                    description: this.description,
                    verticalSpace: 2,
                  ),
                ),
                SizedBox(width: 8),
                Icon(AppIcons.chevronRight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
