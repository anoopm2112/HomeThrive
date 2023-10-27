import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/svg_asset_images.dart';

class FosterShareFullLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          SvgAssetImages.logoNew,
          width: 110,
          height: 110,
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Foster", style: textTheme.headline2),
            Text("Share",
                style: textTheme.headline2.copyWith(color: theme.accentColor)),
          ],
        ),
        SizedBox(height: 4),
        Text(
          localization.poweredByMiracelFoundation,
          style: textTheme.headline3.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            height: 1,
            letterSpacing: 0,
            color: textTheme.headline2.color,
          ),
        ),
      ],
    );
  }
}
