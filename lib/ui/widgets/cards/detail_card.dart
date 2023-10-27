import 'package:flutter/material.dart';
import 'package:fostershare/core/localization/generated/l10n.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';

class DetailCard extends StatelessWidget {
  final void Function() onTap;
  final EdgeInsets margin;
  final String imageUrl;
  final String title;
  final String summary;
  final String actionText;
  final String metaDataText;
  final String alternateImageUrl;

  const DetailCard({
    Key key,
    this.onTap,
    this.margin,
    this.imageUrl,
    @required this.title,
    @required this.summary,
    this.actionText,
    this.metaDataText,
    this.alternateImageUrl,
  })  : assert(title != null),
        assert(summary != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final localization = AppLocalizations.of(context);

    final bool showImage = this.imageUrl != null;
    final bool hasMetaDataText = metaDataText != null;
    return GestureDetector(
      onTap: this.onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        margin: this.margin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showImage)
              AspectRatio(
                aspectRatio: 2.42,
                child: Image.network(
                  // TODO fade in?
                  // TODO placeholder image/fall back image
                  // TODO cached network image?
                  this.imageUrl,
                  width: double.infinity,
                  // height: screenHeighPercentage(context, percentage: 17.4),
                  fit: BoxFit.cover,
                  errorBuilder: (a, b, c) {
                    return Image.network(
                      this.alternateImageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: theme.cardColor,
                        );
                      },
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.title.trim(),
                    style: textTheme.headline1.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: getResponsiveMediumFontSize(context),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    this.summary.trim(),
                    style: textTheme.bodyText2.copyWith(
                      fontSize: getResponsiveSmallFontSize(context),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (hasMetaDataText)
                        Expanded(
                          child: Text(
                            metaDataText.trim(),
                            style: textTheme.bodyText2.copyWith(
                              fontSize: getResponsiveSmallFontSize(context),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          actionText?.trim() ?? localization.readNow,
                          textAlign: hasMetaDataText ? TextAlign.end : null,
                          style: textTheme.bodyText2.copyWith(
                            fontSize: getResponsiveSmallFontSize(context),
                            color: theme.accentColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
