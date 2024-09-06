import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Common/app_colors.dart';


class AppTheme {
  static final light = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldColor,
      listTileTheme: ListTileThemeData(
        tileColor: WidgetStateColor.resolveWith((states) => Colors.white),
        textColor: WidgetStateColor.resolveWith((states) => Colors.black),

      ),

      checkboxTheme: CheckboxThemeData(

        overlayColor:
        WidgetStateColor.resolveWith((states) => AppColors.primary),
        checkColor: WidgetStateColor.resolveWith((states) => AppColors.white),
        fillColor: WidgetStateColor.resolveWith((states) => AppColors.white),
        side: BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(color: AppColors.primary)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) => AppColors.primary),
        overlayColor: WidgetStateColor.resolveWith((states) => Colors.grey),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 2,
        shadowColor: AppColors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 18.0,
            color: AppColors.black,
            fontWeight: FontWeight.w700),
        iconTheme: IconThemeData(color: AppColors.black),
        actionsIconTheme: IconThemeData(color: AppColors.black),
      ),
      dividerColor: const Color(0xFFBFBEBE),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.black,
        selectedIconTheme: IconThemeData(color: AppColors.primary),
        unselectedIconTheme: IconThemeData(color: AppColors.black),
        elevation: 8,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // foregroundColor: Colors.red,
          backgroundColor: Colors.transparent,

          textStyle: GoogleFonts.openSans(
              fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w500),
          // minimumSize: const Size(100, 45),
          // maximumSize:  Size(100, 45),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary,
        actionTextColor: const Color(0xff2a319c),
        contentTextStyle: GoogleFonts.roboto(
            fontSize: 18, color: AppColors.white, fontWeight: FontWeight.w700),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.roboto(
          fontSize: 26,
        ),
        displayLarge: GoogleFonts.roboto(
          fontSize: 24,
          color: Colors.black,
        ),
        displayMedium: GoogleFonts.roboto(
          fontSize: 22,
          color: Colors.black,
        ),
        displaySmall: GoogleFonts.roboto(
          fontSize: 22,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontSize: 20,
          color: Colors.black,
        ),
        headlineSmall: GoogleFonts.roboto(
          fontSize: 20,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.roboto(
          fontSize: 18,
          color: Colors.black,
        ),
        titleMedium: GoogleFonts.roboto(fontSize: 16, color: Colors.black),
        titleSmall: GoogleFonts.roboto(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 14,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          color: Colors.black,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          color: Colors.black,
        ),
        labelLarge: GoogleFonts.roboto(fontSize: 12, color: Colors.white),
        labelMedium: GoogleFonts.roboto(fontSize: 10, color: Colors.white),
        labelSmall: GoogleFonts.roboto(fontSize: 10, color: Colors.black),
      ),
      // colorScheme: ColorScheme.fromSwatch(
      //     primarySwatch: const MaterialColor(
      //       0xFFFFFFFF,
      //       <int, Color>{
      //         50: Color(0xFFFFFFFF),
      //         100: Color(0xFFFFFFFF),
      //         200: Color(0xFFFFFFFF),
      //         300: Color(0xFFFFFFFF),
      //         400: Color(0xFFFFFFFF),
      //         500: Color(0xFFFFFFFF),
      //         600: Color(0xFFFFFFFF),
      //         700: Color(0xFFFFFFFF),
      //         800: Color(0xFFFFFFFF),
      //         900: Color(0xFFFFFFFF),
      //       },
      //     )).copyWith(error: const Color(0xfff71921))
  );


  ///  This is Dark theme for whole application .............
  static final dark = ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.black,
      highlightColor: Colors.green,
      focusColor: Colors.grey,
      // iconTheme: const IconThemeData(color: Colors.white),
      listTileTheme: ListTileThemeData(
        tileColor: WidgetStateColor.resolveWith((states) => Colors.black),
        textColor: WidgetStateColor.resolveWith((states) => Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        selectedIconTheme: IconThemeData(color: Colors.blue),
        unselectedIconTheme: IconThemeData(color: Colors.black),
        elevation: 8,
      ),
      appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w700),
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black)),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateColor.resolveWith((states) => Colors.blue),
        overlayColor: WidgetStateColor.resolveWith((states) => Colors.grey),
      ),
      checkboxTheme: CheckboxThemeData(
        // overlayColor: WidgetStateColor.resolveWith((states) =>Colors.red),
          checkColor: WidgetStateColor.resolveWith((states) => Colors.black),
          fillColor: WidgetStateColor.resolveWith((states) => Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: const BorderSide(color: Colors.green)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // foregroundColor: Colors.red,
          backgroundColor: AppColors.primary,
          textStyle: GoogleFonts.roboto(
              fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w700),
          minimumSize: const Size(145, 40),
          maximumSize: const Size(200, 40),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.roboto(
            fontSize: 26, color: Colors.white, fontWeight: FontWeight.w700),
        displayLarge: GoogleFonts.roboto(
            fontSize: 24, color: Colors.white, fontWeight: FontWeight.w700),
        displayMedium: GoogleFonts.roboto(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.w700),
        displaySmall: GoogleFonts.roboto(
            fontSize: 22, color: Colors.black, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.roboto(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
        headlineSmall: GoogleFonts.roboto(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.roboto(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
        labelMedium: GoogleFonts.roboto(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.roboto(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
        titleSmall: GoogleFonts.roboto(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
        bodyLarge: GoogleFonts.roboto(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.roboto(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
        bodySmall:
        GoogleFonts.roboto(fontSize: 12, color: Colors.red.shade400),
        labelLarge: GoogleFonts.roboto(fontSize: 12, color: Colors.black),
        labelSmall: GoogleFonts.roboto(fontSize: 10, color: Colors.white),
      ));

//  Button Themes.....................
  static final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.red,
    backgroundColor: Colors.red,
    textStyle: GoogleFonts.roboto(
        fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w700),
    minimumSize: const Size(145, 40),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5.0),
      ),
    ),
  );
}
