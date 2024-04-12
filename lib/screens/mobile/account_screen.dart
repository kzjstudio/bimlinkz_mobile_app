import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/create_trades_account_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/preferences.dart';
import 'package:bimlinkz_mobile_app/widgets/account_list_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  final AuthController c = Get.find();

  var data;
  var isLoaded = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 20,
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                      onPressed: () {},
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
                      Get.to(() => PreferencesPage());
                    },
                    icon: Icons.settings_outlined,
                    title: 'Preferences',
                    subTitle: 'Theme, Settings'),
                Divider(
                  thickness: .2,
                  color: Theme.of(context).colorScheme.shadow,
                ),
                ListButton(
                    tapped: () {},
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                    subTitle: 'Ringtone, Message, Notifications'),
                Divider(
                  thickness: .2,
                  color: Theme.of(context).colorScheme.shadow,
                ),
                ListButton(
                    tapped: () {},
                    icon: Icons.help_outline_outlined,
                    title: 'Help',
                    subTitle: 'Contact Us'),
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
