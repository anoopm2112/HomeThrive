import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/responsive_reducers.dart';

class SnippetCard extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String alternateImageUrl;

  const SnippetCard({
    Key key,
    this.onTap,
    @required this.title,
    @required this.subtitle,
    @required this.imageUrl,
    this.alternateImageUrl,
  })  : assert(title != null),
        assert(subtitle != null),
        assert(imageUrl != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: this.onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.zero,
        child: AspectRatio(
          aspectRatio: 11 / 9,
          child: Stack(
            children: [
              Container(
                constraints: BoxConstraints.expand(),
                child: ShaderMask(
                  // TODO class
                  blendMode: BlendMode.srcOver,
                  shaderCallback: (rect) => LinearGradient(
                    begin: Alignment(0, -.25),
                    end: Alignment.bottomCenter,
                    tileMode: TileMode.clamp,
                    colors: [
                      Color(0x0016222B),
                      Color(0xFF121313),
                    ],
                  ).createShader(rect),
                  child: Image.network(
                    this.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Image.network(
                        this.alternateImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(color: theme.canvasColor);
                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        this.title.trim(),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: textTheme.headline2.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: getResponsiveFontSize(
                            context,
                            fontSize: 14,
                            max: 21,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      this.subtitle.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
