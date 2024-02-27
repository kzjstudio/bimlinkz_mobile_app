import 'package:bimlinkz_mobile_app/models/user_model.dart';
import 'package:bimlinkz_mobile_app/screens/landing_screen.dart';
import 'package:bimlinkz_mobile_app/screens/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late Rx<User?> _user;
  var isLoggedIn = false.obs;

  Rx<UserModel> userModel = UserModel().obs;

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
    } else {
      Get.offAll(() => LandingScreen());
    }
  }

  void createUser(String email, String password, String userName) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        var _userId = result.user?.uid;

        addUserToFireStore(_userId.toString(), userName, email);
        initializeUserModel(_userId.toString());
      });

      // if (_user != null) {
      //   Get.snackbar('Sucess', 'You have sucessufully created your account',
      //       snackPosition: SnackPosition.BOTTOM);
      //   Get.offAll(() => LandingScreen());
      // }
      // The user's ID, unique to the Firebase project. Do NOT use this value
    } catch (e) {
      printError();
      Get.snackbar("Error creating account", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      printError();
      Get.snackbar("Sign in failed", "Wrong email or password");
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
    String userId,
    String userName,
    String email,
  ) {
    db
        .collection("users")
        .doc(userId)
        .set({'name': userName, 'id': userId, 'email': email});
  }

  initializeUserModel(String userid) async {
    await db.collection("users").doc(userid).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      print(data);
      UserModel(
          email: data["email"],
          name: data['name'],
          id: data['id'],
          isLoggedIn: true,
          profileImage: 'pic');
    });
  }
}
