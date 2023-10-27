import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

class MedLogDetailCard extends StatelessWidget {
  final void Function() onCardCreated;
  final void Function() onTap;
  final String name;
  final String description;
  final String status;
  final String type;

  const MedLogDetailCard({
    Key key,
    this.onTap,
    this.onCardCreated,
    @required this.name,
    @required this.description,
    this.status,
    this.type = "pastdue",
  })  : assert(name != null),
        assert(description != null),
        super(key: key);
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
                Image.asset(
                  this.type == "pastdue"
                      ? PngAssetImages.pastDue
                      : PngAssetImages.medLog,
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
                  this.status, // TODO
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontSize: 12,
                        color: Color(0xFFE75365),
                      ),
                ),
                SizedBox(width: 8),
                Icon(
                  AppIcons.chevronRight,
                  color: Color(0xFFE75365),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
