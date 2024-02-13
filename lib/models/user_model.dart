import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String profileImage;
  bool isLoggedIn;

  UserModel(
      {this.id = "",
      this.name = "",
      this.email = "",
      this.profileImage = "",
      this.isLoggedIn = false});
}
