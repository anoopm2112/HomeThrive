import 'package:fostershare/ui/common/png_asset_images.dart';
import 'package:meta/meta.dart';

class OnboardingItem {
  final String assetImage;
  final String header;
  final String description;

  OnboardingItem({
    @required this.assetImage,
    @required this.header,
    @required this.description,
  })  : assert(
            assetImage != null && PngAssetImages.values.contains(assetImage)),
        assert(header != null),
        assert(description != null);
}
