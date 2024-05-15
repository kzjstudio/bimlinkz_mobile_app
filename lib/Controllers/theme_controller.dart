import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable for theme mode
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    // Set the initial theme mode based on system settings

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final brightness = Get.context!.theme.brightness;
      themeMode.value =
          (brightness == Brightness.dark) ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Function to toggle theme mode
  void toggleTheme(bool isDarkMode) {
    themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value); // Change theme mode globally in GetX
    saveThemeMode(
        isDarkMode); // Save preference locally, implement this method based on your preference management
  }

  // Getter to determine if current theme is dark
  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  // Implement loading the theme mode when the app starts
  void loadThemeMode() {
    bool isDarkMode =
        loadThemeModeFromPreferences(); // Implement this method to load saved theme preferences
    themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(themeMode.value);
  }

  // Dummy function for saving theme mode in local storage
  void saveThemeMode(bool isDarkMode) {
    // Use shared_preferences or other local storage options to save the theme mode
  }

  // Dummy function for loading theme mode from local storage
  bool loadThemeModeFromPreferences() {
    // Implement loading logic here, return true if dark mode is enabled, otherwise false
    return false; // Default to light mode
  }
}
