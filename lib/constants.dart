import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xff04CEB6); // Main color
  static const Color secondary =
      Color(0xff037C8C); // Complementary secondary color
  static const Color lightBackground =
      Color(0xffF1F1F1); // Light theme background
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
}

// Update Theme Data with enhanced button styles
final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.lightSurface,
    background: AppColors.lightBackground,
    error: AppColors.error,
    onPrimary: AppColors.onPrimary,
    onSecondary: AppColors.onSecondary,
    onSurface: AppColors.buttonText, // Use for better visibility on light theme
    onBackground: AppColors.onBackground,
    onError: AppColors.onError,
  ),
  scaffoldBackgroundColor: AppColors.lightBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    iconTheme: IconThemeData(color: AppColors.onPrimary),
    titleTextStyle: TextStyle(
        color: AppColors.onPrimary, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: AppColors.buttonText, // Text and icon color
      backgroundColor: Colors.transparent,
      side: BorderSide(color: AppColors.primary),
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.darkSurface,
    background: AppColors.darkBackground,
    error: AppColors.error,
    onPrimary: AppColors.onPrimary,
    onSecondary: AppColors.onSecondary,
    onSurface:
        AppColors.buttonDarkText, // Use for better visibility on dark theme
    onBackground: AppColors.onDarkBackground,
    onError: AppColors.onError,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    iconTheme: IconThemeData(color: AppColors.onPrimary),
    titleTextStyle: TextStyle(
        color: AppColors.onPrimary, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: AppColors.buttonDarkText, // Text and icon color
      backgroundColor: Colors.transparent,
      side: BorderSide(color: AppColors.primary),
    ),
  ),
);
