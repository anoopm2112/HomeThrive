import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_icons.dart';
import 'package:fostershare/ui/widgets/cards/card_text_column.dart';
import 'package:fostershare/ui/widgets/creation_aware_widget.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';

class MedicationCard extends StatelessWidget {
  final String name;
  final String description;
  final void Function() onTap;
  const MedicationCard({
    Key key,
    @required this.name,
    @required this.description,
    this.onTap,
  })  : assert(name != null),
        assert(description != null),
        super(key: key);
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
                SizedBox(width: 16),
                Expanded(
                  child: CardTextColumn(
                    title: this.name,
                    description: this.description,
                    verticalSpace: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
