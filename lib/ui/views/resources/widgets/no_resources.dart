import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:fostershare/ui/common/ui_utils.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/views/resources/resources_view_model.dart';
import 'package:stacked/stacked.dart';

class NoResources extends ViewModelWidget<ResourcesViewModel> {
  final String explanationText;

  const NoResources({
    Key key,
    @required this.explanationText,
  })  : assert(explanationText != null),
        super(key: key);

  @override
  Widget build(
    BuildContext context,
    ResourcesViewModel model,
  ) {
    final localization = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1.5 / 1,
            child: Image.asset(
              PngAssetImages.fileCabinet,
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: defaultViewChildPaddingHorizontal,
            child: Text(
              this.explanationText, // TODO
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: model.onModelReady,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sync,
                  color: textTheme.button.color,
                ),
                SizedBox(width: 8),
                Text(
                  localization.reload,
                  style: textTheme.button, // TODO
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
