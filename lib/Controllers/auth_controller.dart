import 'package:bimlinkz_mobile_app/screens/home_screen.dart';
import 'package:bimlinkz_mobile_app/screens/landing_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  final firebaseUser = Rxn<User>();

  var isLoggedIn = false.obs;

  String get user => firebaseUser.value!.email.toString();

  @override
  void onInit() {
    firebaseUser.bindStream(auth.authStateChanges());
  }

  void createUser(String email, String password, String userName) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await user?.updateDisplayName(userName);
      if (firebaseUser.value != null) {
        Get.snackbar('Sucess', 'You have sucessufully created  an account',
            snackPosition: SnackPosition.BOTTOM);
        Get.offAll(() => LandingScreen());
      }
      // The user's ID, unique to the Firebase project. Do NOT use this value
    } catch (e) {
      printError();
      Get.snackbar("Error creating account", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOut() {
    try {
      auth.signOut();
      isLoggedIn.value = false;
    } catch (e) {
      e.printError();
    }
  }
}
