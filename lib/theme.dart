import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme(
    primary: Color(0xFF199a74),
    primaryVariant: Color(0xFF199a74),
    secondary: Color(0xFFFAEA3E),
    secondaryVariant: Color(0xFFFFF159),
    surface: Color(0xFF006d77),
    background: Color(0xFF0b1b2c),
    error: Color(0xFFD64045),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onSurface: Color(0xFFFFFFFF),
    onBackground: Color(0xFFFFFFFF),
    onError: Color(0xFFFFFFFF),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.firaSansTextTheme(
    const TextTheme(
      caption: TextStyle(
        fontSize: 18,
      ),
      button: TextStyle(
        fontSize: 18,
      ),
      headline1: TextStyle(
        fontSize: 45,
        color: Color(0xFFFFFFFF),
        fontWeight: FontWeight.w700,
      ),
      subtitle1: TextStyle(
        fontSize: 20,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w400,
      ),
      bodyText1: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w500,
      ),
      bodyText2: TextStyle(
        color: Color(0xFF2f3e46),
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
);
