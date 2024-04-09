import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/become_a_tradesman_landing_screen.dart';
import 'package:bimlinkz_mobile_app/screens/create_trades_account_screen.dart';
import 'package:bimlinkz_mobile_app/screens/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AccountScreen extends StatelessWidget {
  final AuthController c = Get.find();

  var data;
  var isLoaded = false.obs;

  getUserInfo() {
    final docref = c.db.collection('users').doc(c.auth.currentUser?.uid);
    docref.get().then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
      print(data['name']);
      isLoaded.value = true;
    }, onError: (e) {
      isLoaded.value = false;
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    getUserInfo();
    return Obx(() => isLoaded.isFalse
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              elevation: 20,
              title: Row(
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
                        "${data['name']}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Welcome back!',
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
                        Get.to(() => CreateTradesAccountScreen());
                      }),
                      child: const ListTile(
                        trailing: FaIcon(FontAwesomeIcons.arrowRight),
                        leading: FaIcon(FontAwesomeIcons.plus),
                        title: Text(
                          'Join Bimlinkz',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const ListTile(
                      leading: FaIcon(FontAwesomeIcons.floppyDisk),
                      title: Text(
                        'Saved',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const ListTile(
                      leading: FaIcon(FontAwesomeIcons.arrowRightFromBracket),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
  }
}
