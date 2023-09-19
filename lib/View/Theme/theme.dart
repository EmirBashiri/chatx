import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Light colors
class _LightColors {
  static const Color primary = Color(0xff4A3F69);
  static const Color secondary = Color(0xff000000);
  static const Color secondaryContainer = Color(0xff908986);
  static const Color primaryContainer = Color(0xffEBEAEA);
  static const Color inversePrimary = Color(0xff9747FF);
  static const Color background = Color(0xffFFFFFF);
  static const Color tertiaryContainer = Color(0xffDD1B49);
  static const Color scrim = Colors.blue;
  static const Color error = Colors.red;
}

// Application custom theme
class CustomTheme {
  final ThemeData themeData = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: _LightColors.primary,
      secondary: _LightColors.secondary,
      secondaryContainer: _LightColors.secondaryContainer,
      primaryContainer: _LightColors.primaryContainer,
      inversePrimary: _LightColors.inversePrimary,
      background: _LightColors.background,
      tertiaryContainer: _LightColors.tertiaryContainer,
      scrim: _LightColors.scrim,
      error: _LightColors.error,
    ),
    textTheme: GoogleFonts.aBeeZeeTextTheme().copyWith(
      headlineSmall: GoogleFonts.aBeeZee(
          fontWeight: FontWeight.bold, color: _LightColors.primary),
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xffFFFFFF),
      ),
    ),
  );
}
