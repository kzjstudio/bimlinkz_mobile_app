import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String profileImage;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.profileImage});
}
