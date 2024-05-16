import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // Observable for theme mode
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    // Set the initial theme mode based on system settings

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loadThemeMode();
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
  // Save the theme mode to local preferences
  saveThemeMode(bool isDarkMode) async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isDarkMode', isDarkMode);
    print('theme saved');
  }

  // Load the theme mode from local preferences

  Future<void> loadThemeMode() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    // themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    // Get.changeThemeMode(themeMode.value);

    print('theme loaded');
  }
}
