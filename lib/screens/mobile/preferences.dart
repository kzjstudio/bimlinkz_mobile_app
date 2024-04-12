import 'package:flutter/material.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  ThemeMode themeMode = ThemeMode.system;
  bool isDarkTheme = false;
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Theme and Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Theme'),
            subtitle: const Text('Enable dark theme'),
            value: isDarkTheme,
            onChanged: (bool value) {
              setState(() {
                isDarkTheme = value;
                // Add logic to change theme in app settings
              });
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('Select your language'),
            trailing: DropdownButton<String>(
              value: language,
              onChanged: (String? newValue) {
                setState(() {
                  language = newValue!;
                  // Add logic to change language in app settings
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
          const Padding(
            padding: EdgeInsets.all(8.0),
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
                // Add logic to enable/disable reminders in app settings
              });
            },
          ),
        ],
      ),
    );
  }
}
