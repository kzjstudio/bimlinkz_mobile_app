import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/about_us_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/contact_us_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/contractor_form_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/contractor_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/home_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/notifications.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/preferences.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/profile.dart';
import 'package:bimlinkz_mobile_app/theme.dart';
import 'package:bimlinkz_mobile_app/widgets/list_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  final AuthController c = Get.find();

  AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: UserProfileController.instance.imageUrl.isNotEmpty
                        ? Image.network(
                            UserProfileController.instance.imageUrl.value,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                  ),
                ),
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
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)))),
                      onPressed: () {
                        Get.to(() => const UserProfilePage(),
                            transition: Transition.leftToRightWithFade);
                      },
                      child: const Text('EDIT PROFILE')),
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
                Obx(
                  () => UserProfileController.instance.isContractor.isFalse
                      ? ListTile(
                          onTap: () {
                            Get.to(() => ContractorForm(),
                                transition: Transition.rightToLeftWithFade);
                          },
                          title: const Row(
                            children: [
                              Icon(
                                Icons.add_box_outlined,
                                color: AppColors.primary,
                                size: 30,
                              ),
                              SizedBox(
                                  width:
                                      8), // Space between the icon and the text
                              Text(
                                'Become a Contractor',
                                style: TextStyle(
                                    color: AppColors.primary, fontSize: 20),
                              ),
                            ],
                          ),
                          subtitle: const Text(
                              "Join our network of contractors to access new business opportunities"))
                      : Container(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: .2,
                  color: Theme.of(context).colorScheme.shadow,
                ),
                ListButton(
                    tapped: () {
                      Get.to(() => ContractorsPage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    icon: Icons.work_history_outlined,
                    title: 'Contractors',
                    subTitle: "Person's you have worked with before "),
                Divider(
                  thickness: .2,
                  color: Theme.of(context).colorScheme.shadow,
                ),
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
                ListButton(
                    tapped: () {
                      Get.to(() => const AboutPage(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    icon: Icons.info_outline,
                    title: 'About',
                    subTitle: 'About the application'),
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
