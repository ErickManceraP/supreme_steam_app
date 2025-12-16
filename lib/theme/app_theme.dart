import 'package:flutter/material.dart';

class AppTheme {
  // Modern color palette
  static const primaryBlue = Color(0xFF2D5BFF);
  static const secondaryBlue = Color(0xFF5B8DEF);
  static const accentPurple = Color(0xFF8B5CF6);
  static const accentOrange = Color(0xFFFF6B35);
  static const accentGreen = Color(0xFF10B981);
  static const darkBlue = Color(0xFF1E293B);
  static const mediumGray = Color(0xFF64748B);
  static const lightGray = Color(0xFFF1F5F9);
  static const backgroundColor = Color(0xFFFAFAFA);

  // Gradient definitions
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, secondaryBlue],
  );

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPurple, primaryBlue],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'SF Pro Display',

      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: Colors.white,
        error: Color(0xFFEF4444),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: darkBlue,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkBlue,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkBlue,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkBlue,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkBlue,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkBlue,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkBlue,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkBlue,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: mediumGray,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: mediumGray,
          height: 1.5,
        ),
      ),
    );
  }
}
