import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pemrograman_mobile/app/routes/app_pages.dart';
import '../../account/controllers/account_controller.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final box = GetStorage();
  final AccountController accountController = Get.put(AccountController());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isPasswordVisible = false.obs; // Menggunakan RxBool untuk reaktifitas

  // Register method
  Future<bool> register() async {
    String email = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Username and Password cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        'Success',
        'Account created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Login method
  Future<bool> login() async {
    String email = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Username and Password cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      if (userCredential.user != null) {
        User? user = userCredential.user; 
        print('User ID: ${user?.uid}');
        
        Get.snackbar(
          'Success',
          'Logged in successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        accountController.loadAccountData(); 
        Get.offAllNamed(Routes.ACCOUNT); 
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Login failed, user credential is null',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    await _auth.signOut();
    Get.snackbar(
      'Success',
      'Logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}

