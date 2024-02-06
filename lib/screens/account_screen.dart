import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/become_a_tradesman_landing_screen.dart';
import 'package:bimlinkz_mobile_app/screens/create_account_screen.dart';
import 'package:bimlinkz_mobile_app/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  final AuthController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guest',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Welcome to Bimlinks',
                  style: TextStyle(fontSize: 15),
                )
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
              InkWell(
                onTap: (() {
                  Get.to(() => CreateAccountScreen());
                }),
                child: const ListTile(
                  trailing: Icon(Icons.arrow_right_alt_outlined),
                  leading: Icon(
                    Icons.add_box_outlined,
                  ),
                  title: Text(
                    'Join Bimlinkz',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (() {
                  Get.to(() => SignInScreen());
                }),
                child: const ListTile(
                  leading: Icon(Icons.account_box_outlined),
                  trailing: Icon(Icons.arrow_right_alt_outlined),
                  title: Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Obx(
                () => c.isLoggedIn.value
                    ? Container()
                    : const ListTile(
                        leading: Icon(Icons.account_box_outlined),
                        title: Text(
                          'Account',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
              ),
              Obx(
                () => c.isLoggedIn.value
                    ? Container()
                    : const ListTile(
                        leading: Icon(Icons.favorite_border_outlined),
                        title: Text(
                          'Saved',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
              ),
              FloatingActionButton(onPressed: () {
                if (c.isLoggedIn.value) {
                  c.isLoggedIn.value = false;
                  print("pressed");
                } else {
                  c.isLoggedIn.value = true;
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}



// Row(
//               children: [
//                 const Icon(Icons.add_box_outlined),
//                 TextButton(
//                     onPressed: () {},
//                     child: const Text(
//                       'Join Bimlinkz ',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//                     ))
//               ],
//             ),