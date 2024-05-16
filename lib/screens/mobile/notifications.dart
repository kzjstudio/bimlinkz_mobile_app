import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool pushNotifications = false;
  bool newJobNotifications = false;
  bool messageNotifications = false;
  bool reminderNotifications = false;
  bool sound = true;
  bool ringtone = true;
  bool vibrate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
      ),
      body: ListView(
        padding:
            const EdgeInsets.symmetric(vertical: 12), // Padding around the whole list
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text("General Notifications",
                style: Theme.of(context).textTheme.titleLarge),
          ),
          SwitchListTile(
            title: const Text("Push Notifications"),
            value: pushNotifications,
            onChanged: (bool value) {
              setState(() {
                pushNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text("New Job Notifications"),
            value: newJobNotifications,
            onChanged: (bool value) {
              setState(() {
                newJobNotifications = value;
              });
            },
          ),
          const Divider(), // Divider between sections
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text("Message Notifications",
                style: Theme.of(context).textTheme.titleLarge),
          ),
          SwitchListTile(
            title: const Text("Message"),
            value: messageNotifications,
            onChanged: (bool value) {
              setState(() {
                messageNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Reminders"),
            value: reminderNotifications,
            onChanged: (bool value) {
              setState(() {
                reminderNotifications = value;
              });
            },
          ),
          const Divider(), // Another divider
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text("App Notifications",
                style: Theme.of(context).textTheme.titleLarge),
          ),
          SwitchListTile(
            title: const Text("Sound"),
            value: sound,
            onChanged: (bool value) {
              setState(() {
                sound = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Ringtone"),
            value: ringtone,
            onChanged: (bool value) {
              setState(() {
                ringtone = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Vibrate"),
            value: vibrate,
            onChanged: (bool value) {
              setState(() {
                vibrate = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
