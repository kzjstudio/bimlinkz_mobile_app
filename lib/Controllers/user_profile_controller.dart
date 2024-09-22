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
  var userName = ''.obs;
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
    userName.value = '';
    email.value = '';
    imageUrl.value = '';
  }

  getUser() {
    final docRef = db.collection('users').doc(auth.currentUser?.uid);

    docRef.snapshots().listen((event) {
      // Safely access the fields using `containsKey()`
      var data = event.data() as Map<String, dynamic>?;

      if (data != null) {
        userName.value = data.containsKey('User_Name') ? data['User_Name'] : '';
        firstName.value =
            data.containsKey('First_Name') ? data['First_Name'] : '';
        lastName.value = data.containsKey('Last_Name') ? data['Last_Name'] : '';
        email.value = data.containsKey('Email') ? data['Email'] : '';
        isContractor.value =
            data.containsKey('is_Contractor') ? data['is_Contractor'] : false;
        imageUrl.value = data.containsKey('imageUrl')
            ? data['imageUrl']
            : ''; // Safely access imageUrl
        isConfirmed.value =
            data.containsKey('isConfirmed') ? data['isConfirmed'] : false;

        isLoaded.value = true;
      }
    }, onError: (e) {
      isLoaded.value = false;
      print(e);
    });
  }
}
