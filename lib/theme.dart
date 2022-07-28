import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primary = Color(0xFF199a74);
const Color secondary = Color(0xFFFAEA3E);
const Color background = Color(0xFF0b1b2c);
const Color red = Color(0xFFD64045);
const Color surface = Color(0xFF006d77);
const Color white = Color(0xFFFFFFFF);

final ThemeData darkTheme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: white,
    ),
  ),
  primaryColor: primary,
  // ignore: deprecated_member_use
  accentColor: primary,
  secondaryHeaderColor: primary,
  backgroundColor: background,
  dialogBackgroundColor: background,
  primaryColorDark: red,
  colorScheme: const ColorScheme(
    primary: primary,
    primaryVariant: primary,
    secondary: secondary,
    secondaryVariant: secondary,
    surface: surface,
    background: background,
    error: red,
    onPrimary: white,
    onSecondary: white,
    onSurface: white,
    onBackground: white,
    onError: white,
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
        color: white,
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
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: background,
      shadowColor: surface,
      elevation: 5,
      side: const BorderSide(
        color: surface,
        width: 1,
      ),
      backgroundColor: background,
      fixedSize: const Size(120, 60),
    ),
  ),
);
