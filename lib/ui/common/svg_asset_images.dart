class SvgAssetImages {
  const SvgAssetImages._();

  static const String _svgAssetImagePath = "assets/images/svg";
  static const String _emoticonsSvgAssetPath = "$_svgAssetImagePath/emoticons";
  static const String _incidentsSvgAssetPath = "$_svgAssetImagePath/incidents";
  static const String _svg = "svg";

  static String get anxiety => _svgAssetPath(
        _incidentsSvgAssetPath,
        "anxiety",
      );
  static String get awesome => _svgAssetPath(
        _emoticonsSvgAssetPath,
        "awesome",
      );
  static String get bedWetting => _svgAssetPath(
        _incidentsSvgAssetPath,
        "bed_wetting",
      );
  static String get depression => _svgAssetPath(
        _incidentsSvgAssetPath,
        "depression",
      );
  static String get food => _svgAssetPath(
        _incidentsSvgAssetPath,
        "food",
      );
  static String get good => _svgAssetPath(
        _emoticonsSvgAssetPath,
        "good",
      );
  static String get logo => _svgAssetPath(
        _svgAssetImagePath,
        "logo",
      );
  static String get neutral => _svgAssetPath(
        _emoticonsSvgAssetPath,
        "neutral",
      );
  static String get notGreat => _svgAssetPath(
        _emoticonsSvgAssetPath,
        "not_great",
      );
  static String get other => _svgAssetPath(
        _incidentsSvgAssetPath,
        "other",
      );
  static String get sad => _svgAssetPath(
        _emoticonsSvgAssetPath,
        "sad",
      );
  static String get school => _svgAssetPath(
        _incidentsSvgAssetPath,
        "school",
      );
  static String get violence => _svgAssetPath(
        _incidentsSvgAssetPath,
        "violence",
      );

  static String get logoNew => _svgAssetPath(
        _svgAssetImagePath,
        "logo_new",
      );

  static final values = [
    awesome,
    bedWetting,
    depression,
    food,
    good,
    logo,
    neutral,
    notGreat,
    other,
    sad,
    violence,
    logoNew,
  ];

  static String _svgAssetPath(String path, String assetFileName) {
    return "$path/$assetFileName.$_svg";
  }
}
