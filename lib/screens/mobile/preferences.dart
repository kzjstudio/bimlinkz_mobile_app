import 'package:bimlinkz_mobile_app/Controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  ThemeMode themeMode = ThemeMode.system;
  RxBool isDarkTheme = false.obs; // Updated to use GetX observable
  bool isRemindersOn = false;
  String language = 'English'; // Example default language

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10), // Adds space at the top of the list
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Theme and Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(
            () => SwitchListTile(
              title: const Text('Dark Theme'),
              subtitle: const Text('Enable dark theme'),
              value: isDarkTheme.value,
              onChanged: (bool value) {
                isDarkTheme.value = value;
                Get.find<ThemeController>().toggleTheme(value);
              },
            ),
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('Select your language'),
            trailing: DropdownButton<String>(
              value: language,
              onChanged: (String? newValue) {
                setState(() {
                  language = newValue!;
                });
              },
              items: <String>['English', 'Spanish', 'French']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const Divider(), // Visual separator
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'App Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text('Reminders'),
            subtitle: const Text('Turn reminders on or off'),
            value: isRemindersOn,
            onChanged: (bool value) {
              setState(() {
                isRemindersOn = value;
              });
            },
          ),
          const SizedBox(height: 20), // Adds space at the bottom of the list
        ],
      ),
    );
  }
}
