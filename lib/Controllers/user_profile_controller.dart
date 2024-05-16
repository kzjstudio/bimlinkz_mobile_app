import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  static UserProfileController instance = Get.find();

  String? profileImageUrl;
  var specialty = ''.obs;
  var about = ''.obs;
  var email = ''.obs;
  var isAccountFinished = false.obs;
  String? phoneNumber;
  String? address;
  String? resumeUrl;
  var name = ''.obs;
  List<String> skills = [];
  var isLoaded = false.obs;
  var isUserProfileFinished = false.obs;

  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    getUser();
    super.onReady();
  }

  getUser() {
    final docref = db.collection('users').doc(auth.currentUser?.uid);
    docref.snapshots().listen((event) {
      name.value = event['name'];
      email.value = event['email'];
      isUserProfileFinished.value = event['isuserprofilefinished'];
      isAccountFinished.value = event['isAccountFinished'];
      print(name.value);
      print(email.value);
      print(isAccountFinished);
      isLoaded.value = true;
    });
    (e) {
      isLoaded.value = false;
      print(e);
    };
  }
}
