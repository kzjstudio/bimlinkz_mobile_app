import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xff5664F5); // Main color
  static const Color secondary =
      Color(0xffF0F1FF); // Complementary secondary color
  static const Color lightBackground =
      Color.fromARGB(255, 255, 255, 255); // Light theme background
  static const Color lightSurface = Color(0xffffffff); // Light theme surface
  static const Color darkBackground =
      Color(0xff303030); // Dark theme background
  static const Color darkSurface = Color(0xff424242); // Dark theme surface
  static const Color error = Color(0xffB00020); // Error color
  static const Color onPrimary = Color(0xffffffff); // Text on primary color
  static const Color onSecondary = Color(0xffffffff); // Text on secondary color
  static const Color onBackground =
      Color(0xff000000); // Text on light background
  static const Color onSurface = Color(0xff000000); // Text on light surface
  static const Color onDarkBackground =
      Color(0xffffffff); // Text on dark background
  static const Color onDarkSurface = Color(0xffffffff); // Text on dark surface
  static const Color onError = Color(0xffffffff); // Text on error color
  static const Color buttonText =
      Color(0xff000000); // Button text color for light theme
  static const Color buttonDarkText =
      Color(0xffffffff); // Button text color for dark theme
  static const Color unselectedIcon = Color.fromARGB(255, 114, 114, 114);
  static const Color divider = Color.fromARGB(255, 221, 221, 221);
}

// Update Theme Data with enhanced button styles
final ThemeData lightTheme = ThemeData(
    fontFamily: 'Lexend',
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSurface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.buttonText,
      // Use for better visibility on light theme

      onError: AppColors.onError,
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      iconTheme: IconThemeData(color: AppColors.darkBackground),
      titleTextStyle: TextStyle(
          color: AppColors.buttonText,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary, // Text and icon color
        backgroundColor: Colors.transparent,
        side: const BorderSide(color: AppColors.primary),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.lightBackground,
        unselectedIconTheme: IconThemeData(color: AppColors.buttonText),
        selectedIconTheme: IconThemeData(color: AppColors.primary)),
    dividerTheme: const DividerThemeData(color: AppColors.divider));

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Lexend',
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.darkSurface,

    error: AppColors.error,
    onPrimary: AppColors.onPrimary,
    onSecondary: AppColors.onSecondary,
    onSurface:
        AppColors.buttonDarkText, // Use for better visibility on dark theme

    onError: AppColors.onError,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    iconTheme: IconThemeData(color: AppColors.onDarkBackground),
    titleTextStyle: TextStyle(
      color: AppColors.onDarkBackground,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary, // Text and icon color
      backgroundColor: Colors.transparent,
      side: const BorderSide(color: AppColors.primary),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: AppColors.darkBackground,
    unselectedIconTheme: IconThemeData(color: AppColors.unselectedIcon),
    selectedIconTheme: IconThemeData(color: AppColors.primary),
  ),
  dividerTheme: const DividerThemeData(color: AppColors.divider),
);
