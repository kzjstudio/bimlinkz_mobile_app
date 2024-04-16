import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  static UserProfileController instanc = Get.find();

  String? profileImageUrl;
  var specialty = ''.obs;
  var about = ''.obs;
  var email = ''.obs;
  String? phoneNumber;
  String? address;
  String? resumeUrl;
  var name = ''.obs;
  List<WorkExperience> workExperiences = [];
  List<String> skills = [];
  List<Education> education = [];
  var isLoaded = false.obs;

  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    getUser();
    super.onReady();
    print('getting data');
  }

  getUser() {
    final docref = db.collection('users').doc(auth.currentUser?.uid);
    docref.get().then((DocumentSnapshot doc) {
      var data = doc.data() as Map<String, dynamic>;
      name.value = data['name'];
      email.value = data['email'];
      about.value = data['about'];
      print(name.value);
      print(email.value);
      isLoaded.value = true;
    }, onError: (e) {
      isLoaded.value = false;
      print(e);
    });
  }
}

class WorkExperience {
  String company;
  String position;
  String duration; // Could be enhanced with DateTime for start and end date

  WorkExperience(
      {required this.company, required this.position, required this.duration});
}

class Education {
  String schoolName;
  String duration; // Example: "2012 - 2016"

  Education({required this.schoolName, required this.duration});
}
