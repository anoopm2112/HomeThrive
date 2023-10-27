import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/circle_painter.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/widgets/user_avatar.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

class RecLogCard extends StatelessWidget {
  final void Function() onCardCreated;
  final void Function() onTap;
  final ImageProvider<Object> image;
  final String name;
  final String description;

  RecLogCard({
    Key key,
    this.onTap,
    this.onCardCreated,
    this.image,
    @required this.name,
    @required this.description,
  }) : super(key: key) {
    assert(name != null);
    assert(description != null);
  }
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return CreationAwareWidget(
      onWidgetCreated: this.onCardCreated,
      child: GestureDetector(
        onTap: this.onTap,
        child: Card(
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
                  PngAssetImages.recLog,
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
