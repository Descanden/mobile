import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final box = GetStorage();

  void login() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String storedPassword = box.read('password') ?? '';

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Username and Password cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (username == 'sasha' && password == storedPassword) {
      Get.snackbar(
        'Success',
        'Logged in successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.toNamed('/account');
    } else {
      Get.snackbar(
        'Error',
        'Invalid username or password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
