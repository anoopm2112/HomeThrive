import 'dart:math';

import 'package:flutter/widgets.dart';

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
double screenArea(BuildContext context) =>
    screenWidth(context) * screenHeight(context);

double screenWidthPercentage(BuildContext context, {double percentage = 0}) {
  assert(percentage >= 0);
  return screenWidth(context) * (percentage / 100);
}

double screenHeightPercentage(BuildContext context, {double percentage = 0}) {
  assert(percentage >= 0);
  print(screenHeight(context) * (percentage / 100));
  return screenHeight(context) * (percentage / 100);
}

double screenHeightFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    min((screenHeight(context) - offsetBy) / dividedBy, max);

double screenWidthFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    min((screenWidth(context) - offsetBy) / dividedBy, max);

double getResponsiveSmallFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 14, max: 15);

double getResponsiveMediumFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 17, max: 18);

double getResponsiveLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 21, max: 31);

double getResponsiveExtraLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 25);

double getResponsiveMassiveFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 30);

double getResponsiveFontSize(
  BuildContext context, {
  @required double fontSize,
  double max = 100,
}) {
  assert(fontSize != null);
  assert(max != null);

  final double responsiveSize =
      min(screenWidthFraction(context) * (fontSize / 100), max);

  return responsiveSize;
}

double getAreaResponsiveFontSize(
  BuildContext context, {
  @required double fontSize,
  double max = 100,
}) {
  assert(fontSize != null);
  assert(max != null);

  print(screenArea(context) * (fontSize / 100));
  final double responsiveSize =
      min(screenArea(context) * (fontSize / 100), max);

  return responsiveSize;
}
