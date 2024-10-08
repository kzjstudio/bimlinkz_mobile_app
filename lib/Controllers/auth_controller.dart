import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/email_comfirmation_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/landing_screen.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late Rx<User?> user;
  var isLoggedIn = false.obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    user = Rx<User?>(auth.currentUser);
    user.bindStream(auth.userChanges());
    ever(user, _initialScreen);
  }

  _initialScreen(User? user) async {
    if (user == null) {
      UserProfileController.instance.resetuser();
      Get.offAll(() => const LoginScreen());
      isLoggedIn.value = false;
    } else {
      // Fetch the user from Firestore
      DocumentSnapshot userSnapshot =
          await db.collection("users").doc(user.uid).get();

      if (userSnapshot.exists) {
        bool isConfirmed = userSnapshot['isConfirmed'];

        if (isConfirmed) {
          // If the user is confirmed, go to the Landing Screen
          Get.offAll(() => const LandingScreen());
          isLoggedIn.value = true;
        } else {
          // If the user is not confirmed, go to the Email Confirmation Screen
          Get.offAll(() => EmailConfirmationScreen(email: user.email!));
        }
      } else {
        signOut();
      }
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserProfileController.instance.getUser();
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  void createUser(String email, String password, String firstName,
      String lastName, String confirmationCode) async {
    isLoading.value = true;
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) async {
        var userId = result.user?.uid;

        // Add user to Firestore and wait for it to complete
        await addUserToFireStore(
            userId.toString(), firstName, lastName, email, confirmationCode);

        // Fetch and initialize user profile data
        await UserProfileController.instance.getUser();

        // Redirect to the Email Confirmation Screen after the Firestore document is created
        Get.to(() => EmailConfirmationScreen(email: email));
      });
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false; // Stop loading state
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
      UserProfileController.instance.resetuser();
    } catch (e) {
      e.printError();
    }
  }

  Future<void> addUserToFireStore(
    String userId,
    String firstName,
    String lastName,
    String email,
    String confirmationCode,
  ) async {
    await db.collection("users").doc(userId).set({
      'First_Name': firstName,
      'Last_Name': lastName,
      'id': userId,
      'Email': email,
      'Date_Joined': Timestamp.now(),
      'is_Contractor': false,
      'confirmationCode': confirmationCode,
      'isConfirmed': false,
    });
  }
}
