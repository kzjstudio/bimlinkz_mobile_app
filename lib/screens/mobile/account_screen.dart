import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/about_us_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/contact_us_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/notifications.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/preferences.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/profile.dart';
import 'package:bimlinkz_mobile_app/widgets/list_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  final AuthController c = Get.find();

  var data;
  var isLoaded = false.obs;

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.userName.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Welcome back!',
                    style: TextStyle(fontSize: 15),
                  ),
                  OutlinedButton(
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)))),
                      onPressed: () {
                        Get.to(() => const UserProfilePage(),
                            transition: Transition.leftToRightWithFade);
                      },
                      child: const Text('EDIT PROFILE'))
                ],
              )
            ],
          ),
          toolbarHeight: 150,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListButton(
                    tapped: () {
                      Get.to(() => const PreferencesPage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    icon: Icons.settings_outlined,
                    title: 'Preferences',
                    subTitle: 'Theme, Settings'),
                Divider(
                  thickness: .2,
                  color: Theme.of(context).colorScheme.shadow,
                ),
                ListButton(
                    tapped: () {
                      Get.to(() => const NotificationSettingsPage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    subTitle: 'Ringtone, Message, Notifications'),
                Divider(
                  thickness: .2,
                  color: Theme.of(context).colorScheme.shadow,
                ),
                ListButton(
                    tapped: () {
                      Get.to(() => const ContactUsPage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    icon: Icons.help_outline_outlined,
                    title: 'Help',
                    subTitle: 'Contact Us'),
                Divider(
                  thickness: .2,
                  color: Theme.of(context).colorScheme.shadow,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const AboutPage(),
                        transition: Transition.rightToLeftWithFade);
                  },
                  child: const ListTile(
                    dense: true,
                    isThreeLine: true,
                    leading: Icon(
                      Icons.info_outline,
                    ),
                    title: Text(
                      'About',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('About the application'),
                  ),
                ),
                Divider(
                  thickness: .2,
                  color: Theme.of(context).colorScheme.shadow,
                ),
                GestureDetector(
                  onTap: () {
                    c.signOut();
                  },
                  child: ListTile(
                    dense: true,
                    isThreeLine: true,
                    leading: Icon(
                      Icons.logout_outlined,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      'Log out',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    subtitle: const Text('Exit from your account'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
