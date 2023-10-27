import 'package:flutter/material.dart';
import 'package:fostershare/ui/common/app_colors.dart';
import 'package:fostershare/ui/common/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  Themes._();

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.gray100,
      primaryColor: AppColors.orange500,
      errorColor: AppColors.orange500,
      accentColor: AppColors.orange500,
      colorScheme: ColorScheme.light(primary: AppColors.orange500),
      dialogBackgroundColor: AppColors.white,
      canvasColor: AppColors.gray100,
      backgroundColor: AppColors.black600,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.orange500,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.orange500,
        // selectedLabelStyle: , // TODO
        // unselectedLabelStyle: ,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.gray400),
        backgroundColor: AppColors.white,
        titleTextStyle: GoogleFonts.montserrat(
          textStyle: Styles.headline3,
          color: AppColors.black900,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.orange500,
          primary: AppColors.orange500,
          onSurface: AppColors.orange500,
          minimumSize: Size(88, 50),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          textStyle: GoogleFonts.montserrat(
            // TODO button textTheme
            textStyle: Styles.button,
            color: AppColors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // backgroundColor: AppColors.orange500,
          primary: AppColors.orange500,
          onSurface: AppColors.orange500,
          minimumSize: Size(88, 50),
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          textStyle: GoogleFonts.montserrat(
            // TODO button textTheme
            textStyle: Styles.button,
            color: AppColors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(88, 50),
          side: BorderSide(
            color: AppColors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      buttonTheme: ButtonThemeData(
        // TODO need?
        height: 50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        focusColor: AppColors.orange500,
        contentPadding: EdgeInsets.only(left: 20),
        labelStyle: GoogleFonts.montserrat(
          textStyle: Styles.inputLabelStyle,
          // color: AppColors.gray400,
        ),
        hintStyle: GoogleFonts.montserrat(
          textStyle: Styles.inputLabelStyle,
          color: AppColors.orange500,
        ),
        errorStyle: GoogleFonts.montserrat(
          textStyle: Styles.inputErrorStyle,
          color: AppColors.white,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: AppColors.orange500,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: AppColors.orange500,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: AppColors.orange500,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Color(0xFFE6E6E6),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: AppColors.orange500,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textTheme: TextTheme(
        headline1: GoogleFonts.playfairDisplay(
          textStyle: Styles.headline1,
          color: AppColors.black900,
        ),
        headline2: GoogleFonts.playfairDisplay(
          textStyle: Styles.headline2,
          color: AppColors.white,
        ),
        headline3: GoogleFonts.montserrat(
          textStyle: Styles.headline3,
          color: AppColors.black900,
        ),
        bodyText1: GoogleFonts.montserrat(
          textStyle: Styles.bodyText1,
          color: AppColors.gray400,
        ),
        bodyText2: GoogleFonts.montserrat(
          textStyle: Styles.bodyText1,
          color: AppColors.gray600,
        ),
        button: GoogleFonts.montserrat(
          // TODO button textTheme
          textStyle: Styles.button,
          color: AppColors.white,
        ),
      ),
      shadowColor: AppColors.gray200
    );
  }
}
