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
  var imageUrl = "".obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  List<String> skills = [];
  var isLoaded = false.obs;
  var isContractor = false.obs;
  var isConfirmed = false.obs;

  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    getUser();
    super.onReady();
  }

  resetuser() {
    firstName.value = '';
    email.value = '';
    imageUrl.value = '';
  }

  getUser() {
    final docref = db.collection('users').doc(auth.currentUser?.uid);
    docref.snapshots().listen((event) {
      firstName.value = event['First_Name'];
      lastName.value = event["Last_Name"];
      email.value = event['Email'];
      isContractor.value = event['is_Contractor'];
      isLoaded.value = true;
      imageUrl.value = event['imageUrl'];
      isConfirmed.value = event['isConfirmed'];
    });
    (e) {
      isLoaded.value = false;
      print(e);
    };
    print('got user info');
  }
}
