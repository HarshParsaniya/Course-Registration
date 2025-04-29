import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF3F51B5);
  static const Color accentColor = Color(0xFF536DFE);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFE53935);
  static const Color textColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);

  // Dark theme colors
  static const Color darkPrimaryColor = Color(0xFF3F51B5);
  static const Color darkAccentColor = Color(0xFF536DFE);
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Color(0xFFEEEEEE);
  static const Color darkSecondaryTextColor = Color(0xFFAAAAAA);

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      background: backgroundColor,
      surface: cardColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    textTheme: TextTheme(
      displayLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 28),
      displayMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
      headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
      headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
      headlineSmall: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
      titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
      bodyLarge: TextStyle(color: textColor, fontSize: 16),
      bodyMedium: TextStyle(color: secondaryTextColor, fontSize: 14),
    ),
    appBarTheme: AppBarTheme(
      color: primaryColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: errorColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: darkPrimaryColor,
    colorScheme: ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkAccentColor,
      error: errorColor,
      background: darkBackgroundColor,
      surface: darkCardColor,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: darkCardColor,
    textTheme: TextTheme(
      displayLarge: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 28),
      displayMedium: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 24),
      headlineLarge: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 20),
      headlineMedium: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 18),
      headlineSmall: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 16),
      titleLarge: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold, fontSize: 14),
      bodyLarge: TextStyle(color: darkTextColor, fontSize: 16),
      bodyMedium: TextStyle(color: darkSecondaryTextColor, fontSize: 14),
    ),
    appBarTheme: AppBarTheme(
      color: darkPrimaryColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkAccentColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: errorColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}
