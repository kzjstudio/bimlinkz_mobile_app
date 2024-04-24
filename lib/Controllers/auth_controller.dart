import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/landing_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late Rx<User?> _user;
  var isLoggedIn = false.obs;
  var userName = ''.obs;
  var isLoaded = false.obs;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print('Login');
      Get.offAll(() => LoginScreen());
      isLoggedIn.value = false;
    } else {
      Get.offAll(() => LandingScreen());
      isLoggedIn.value = true;
    }
  }

  void createUser(
      String email, String password, String userName, String role) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        var _userId = result.user?.uid;

        addUserToFireStore(_userId.toString(), userName, email, role);
        UserProfileController.instance.getUser();
      });
    } catch (e) {
      printError();
      Get.snackbar("Error creating account", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      UserProfileController.instance.getUser();
    } catch (e) {
      printError();
      Get.snackbar("Sign in failed", "Wrong email or password",
          snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 5));
    }
  }

  signOut() {
    try {
      auth.signOut();
      print("signed out");
    } catch (e) {
      e.printError();
    }
  }

  void addUserToFireStore(
      String userId, String userName, String email, String role) {
    db.collection("users").doc(userId).set({
      'name': userName,
      'id': userId,
      'email': email,
      'datejoined': Timestamp.now(),
      'role': role
    });
  }
}
