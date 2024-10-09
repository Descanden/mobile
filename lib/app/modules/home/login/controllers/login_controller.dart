import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pemrograman_mobile/app/routes/app_pages.dart';
import '../../account/controllers/account_controller.dart'; // Make sure to import the AccountController

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final box = GetStorage();
  final AccountController accountController = Get.put(AccountController()); // Create an instance of AccountController

  Future<bool> login() async { // Change the return type to Future<bool>
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
      return false; // Return false if validation fails
    } else if (username == 'sasha' && password == storedPassword) {
      Get.snackbar(
        'Success',
        'Logged in successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      accountController.loadAccountData(); // Load the account data after successful login
      Get.offAllNamed(Routes.ACCOUNT); // Navigate to the account page
      return true; // Return true on successful login
    } else {
      Get.snackbar(
        'Error',
        'Invalid username or password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false; // Return false for invalid credentials
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
