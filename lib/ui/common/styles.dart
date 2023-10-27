import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO do better
class Styles {
  Styles._();

  static TextStyle get headline1 => TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 34,
        height: 1.206,
        letterSpacing: .41,
      );

  static TextStyle get headline2 => TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 36,
        height: .889,
      );

  static TextStyle get headline3 => TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 36,
        height: .889,
      );

  static TextStyle get bodyText1 => TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.143,
        letterSpacing: .25,
      );

  static TextStyle get bodyText2 => TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 1.143,
        letterSpacing: .25,
      );

  static TextStyle get inputLabelStyle => TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );

  static TextStyle get inputErrorStyle => TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
      );

  static TextStyle get button => TextStyle(
        // TODO buttonTextTheme
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 1.375,
        letterSpacing: .35,
      );

  static TextStyle get title1 => GoogleFonts.playfairDisplay();

  static TextStyle get title2 => GoogleFonts.getFont(
        'PlayfairDisplay',
        color: Color(0xFF0D1724),
        fontWeight: FontWeight.bold,
        fontSize: 24,
      );

  static TextStyle get subtitle1 => GoogleFonts.montserrat();
}

// TODO do better
extension TextStyleHelper on TextStyle {
  TextStyle stylesOverride({
    String fontFamily,
    Color color,
    double fontSize,
    FontWeight fontWeight,
    double height,
  }) =>
      GoogleFonts.getFont(
        fontFamily ?? _baseFontFamily(this.fontFamily),
        color: color ?? this.color,
        fontSize: fontSize ?? this.fontSize,
        fontWeight: fontWeight ?? this.fontWeight,
        height: height ?? this.height,
      );
}

String _baseFontFamily(String fontFamily) => fontFamily.split('_')[0];
