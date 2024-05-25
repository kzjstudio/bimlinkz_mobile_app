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
  late Rx<User?> user;
  var isLoggedIn = false.obs;
  var userName = ''.obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    user = Rx<User?>(auth.currentUser);
    user.bindStream(auth.userChanges());
    ever(user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      UserProfileController.instance.resetuser();
      Get.offAll(() => const LoginScreen());
      isLoggedIn.value = false;
    } else {
      Get.offAll(() => const LandingScreen());
      isLoggedIn.value = true;
    }
  }

  void createUser(
    String email,
    String password,
    String userName,
  ) async {
    isLoading.value = true;
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        var userId = result.user?.uid;

        addUserToFireStore(userId.toString(), userName, email);
        UserProfileController.instance.getUser();
      });
      isLoading.value = false;
    } catch (e) {
      printError();
      Get.snackbar("Error creating account", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  signIn(String email, String password) async {
    isLoading.value = true;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      UserProfileController.instance.getUser();
      isLoading.value = false;
    } catch (e) {
      printError();
      Get.snackbar("Sign in failed", "Wrong email or password",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5));
    }
  }

  signOut() {
    try {
      auth.signOut();
    } catch (e) {
      e.printError();
    }
  }

  void addUserToFireStore(String userId, String userName, String email) {
    db.collection("users").doc(userId).set({
      'User_Name': userName,
      'id': userId,
      'Email': email,
      'Date_Joined': Timestamp.now(),
      'is_Contractor': false,
    });
  }
}
