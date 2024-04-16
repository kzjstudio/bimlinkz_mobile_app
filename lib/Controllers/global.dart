import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/Controllers/user_profile_controller.dart';
import 'package:get/get.dart';

class Global {
  static init() {
    Get.put(AuthController());
    Get.put<UserProfileController>(UserProfileController());
  }
}
