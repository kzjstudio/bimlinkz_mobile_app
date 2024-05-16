import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/jobpost_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/profile.dart';
import 'package:bimlinkz_mobile_app/widgets/category_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

var collection = FirebaseFirestore.instance.collection('categories').get();

final AuthController c = Get.find();
final UserProfileController usercontroller = Get.find();

class _HomeScreenState extends State<HomeScreen> {
  showFinisheProfileMessage() {
    if (UserProfileController.instance.isUserProfileFinished.isFalse) {
      Get.defaultDialog(
        radius: 8.0, // Rounded corners for the dialog
        title: 'Finish Setting Up Your Profile',
        titleStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        middleText: '',
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => const UserProfilePage());
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30), // Rounded corners for the button
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            child: const Text(
              'Go to User Profile',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        barrierDismissible:
            true, // Allows dismissing the dialog by tapping outside of it
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Hello,'),
              Obx(() => Text(
                    usercontroller.name.value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ))
            ]),
            actions: [
              Obx(() => IconButton(
                    onPressed: () {
                      print(UserProfileController.instance.isAccountFinished);
                      showFinisheProfileMessage();
                    },
                    icon:
                        UserProfileController.instance.isAccountFinished.isTrue
                            ? const Icon(Icons.notifications_none)
                            : const Icon(
                                Icons.notification_important_outlined,
                                color: Colors.orange,
                              ),
                    iconSize: 25,
                  )),
            ],
          ),
          body: FutureBuilder(
              future: collection,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {},
                              ),
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Popular searches',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text('See all'))
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 130,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final data = snapshot.data!.docs;
                                  return CategoryCard(
                                    catText: data[index]["id"],
                                    imageUrl: data[index]['imageUrl'],
                                  );
                                }),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey.shade300,
                            child: const Center(child: Text('Feature Area')),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey.shade300,
                            child: const Center(child: Text('Feature Area')),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey.shade300,
                            child: const Center(child: Text('Feature Area')),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => const PostJobPage(),
                  transition: Transition.downToUp,
                  duration: const Duration(milliseconds: 200));
            },
            child: const Icon(Icons.post_add_outlined),
          ),
        ),
      ),
    );
  }
}
