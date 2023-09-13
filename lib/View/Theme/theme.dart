import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  final ThemeData themeData = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Color(0xff4A3F69),
      secondary: Color(0xff000000),
      primaryContainer: Color(0xffEBEAEA),
      inversePrimary: Color(0xff9747FF),
      background: Color(0xffFFFFFF),
      tertiaryContainer: Color(0xffDD1B49),
      scrim: Colors.blue,
      error: Colors.red,
    ),
    textTheme: GoogleFonts.aBeeZeeTextTheme(),
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
