import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFFFF9E0F); // LeetCode-like orange
const Color kSecondaryColor = Color(0xFF00FFB3);
const Color kSurfaceColor = Color(0xFF2A2A2A);
const Color kErrorColor = Color(0xffF53836);
const Color kSuccessColor = Colors.green;
const Color kSuccessAccentColor = Color(0xff1ABBBB);
const Color kWarningColor = Color(0xffFEB600);
const Color kBackgroundColor = Color(0xFF1C1C1C);
const Color kTextColor = Color(0xFFD4D4D4);
const Color kHintColor = Color(0xFFB3B3B3);
const Color kBorderColor = Color(0xFF707070);
const Color kInputFillColor = Color(0xFF2E2E2E);
const Color kAppBarColor = Color(0xFF2A2A2A);

final ThemeData leetcodeTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Lato',
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: kBackgroundColor,
  colorScheme: const ColorScheme.dark(
    primary: kPrimaryColor,
    secondary: kSecondaryColor,
    surface: kSurfaceColor,
    error: kErrorColor,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: kTextColor,
    contentTextStyle: TextStyle(
      color: kBackgroundColor,
      fontSize: 18,
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: kAppBarColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: kTextColor,
      fontSize: 16,
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: kSurfaceColor,
    disabledColor: Colors.grey,
    selectedColor: kPrimaryColor,
    secondarySelectedColor: kSecondaryColor,
    labelStyle: const TextStyle(color: kTextColor, fontSize: 12),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: const BorderSide(
        color: kBorderColor,
        width: 1.0,
      ),
    ),
  ),
  scrollbarTheme: ScrollbarThemeData(
    interactive: true,
    thumbVisibility: WidgetStateProperty.all(true),
    radius: const Radius.circular(10),
    thickness: WidgetStateProperty.all(6),
    minThumbLength: 30,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[850],
    selectedItemColor: kPrimaryColor,
    unselectedItemColor: Colors.grey[400],
    showSelectedLabels: true,
    showUnselectedLabels: false,
    selectedLabelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: kPrimaryColor,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
      color: Colors.grey[400],
    ),
    type: BottomNavigationBarType.shifting,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: kTextColor,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: kTextColor,
      fontSize: 14,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      iconColor: kPrimaryColor,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: kSurfaceColor,
      iconColor: kSurfaceColor,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kInputFillColor,
    hintStyle: const TextStyle(color: kHintColor),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: kPrimaryColor),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: kBorderColor),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: kPrimaryColor, width: 2),
    ),
  ),
);

extension ColorSchemeExt on ColorScheme {
  Color get successColorAccent => kSuccessAccentColor;
  Color get successColor => kSuccessColor;
  Color get warningColor => kWarningColor;
}
