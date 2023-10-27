import 'package:flutter/widgets.dart';

class ShadedImage extends StatelessWidget {
  final BlendMode blendMode;
  final Uri imageUrl;
  final List<Color> colors;

  const ShadedImage({
    Key key,
    this.blendMode = BlendMode.srcOver,
    this.imageUrl,
    this.colors,
  })  : assert(blendMode != null),
        assert(imageUrl != null),
        assert(colors != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: this.blendMode,
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
        this.imageUrl.toString(),
        fit: BoxFit.cover,
      ),
    );
  }
}
