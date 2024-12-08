import 'package:flutter/material.dart';

final ThemeData leetcodeTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Lato',
  primaryColor: const Color.fromRGBO(255, 158, 15, 1), // LeetCode-like orange
  scaffoldBackgroundColor: const Color(0xFF1C1C1C), // Dark background

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFF9E0F), // Primary color for buttons and main accents
    secondary: Color(0xFF00FFB3),
    surface: Color(0xFF2A2A2A),
    error: Color(0xffF53836),
  ),

  appBarTheme: const AppBarTheme(
    color: Color(0xFF2A2A2A), // Darker shade for app bar
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xFFD4D4D4),
      fontSize: 16,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFFFF9E0F),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[850], // Dark background for nav bar
    selectedItemColor: Color(0xFFFF9E0F), // Accent color for selected item
    unselectedItemColor: Colors.grey[400], // Subtle grey for unselected items
    showSelectedLabels: true,
    showUnselectedLabels: false,
    selectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Color(0xFFFF9E0F),
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
      color: Colors.grey[400],
    ),
    type: BottomNavigationBarType.shifting, // Makes all items appear equally
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: Color(0xFFD4D4D4),
      fontSize: 16,
    ), // Light gray for readability
    bodyMedium: TextStyle(
      color: Color(0xFFD4D4D4),
      fontSize: 14,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: Colors.grey[850],
      padding: EdgeInsets.all(
        8,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFF9E0F), // LeetCode orange
      foregroundColor: Color(0xFF2A2A2A), // Text color
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF2E2E2E), // Dark background for input fields
    hintStyle:
        const TextStyle(color: Color(0xFFB3B3B3)), // Light gray hint text
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFFF9E0F)),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide:
          BorderSide(color: Color(0xFF707070)), // Lighter border for enabled
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide:
          BorderSide(color: Color(0xFFFF9E0F), width: 2), // Orange on focus
    ),
  ),
);

extension ColorSchemeExt on ColorScheme {
  Color get successColorAccent {
    return Color(0xff1ABBBB);
  }

  Color get successColor {
    return Colors.green;
  }

  Color get warningColor {
    return Color(0xffFEB600);
  }
}
