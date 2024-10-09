import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PasswordMismatchException implements Exception {
  final String message;
  PasswordMismatchException(this.message);
}

class PasswordIncorrectException implements Exception {
  final String message;
  PasswordIncorrectException(this.message);
}

class PasswordManagerController extends GetxController {
  var oldPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  final box = GetStorage();


  void updatePassword() {
    String storedPassword = box.read('password') ?? '';

    // Check if fields are empty
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Pastikan semua field telah terisi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return; // Return early if any field is empty
    }

    // Validate old password
    if (oldPassword.value != storedPassword) {
      throw PasswordIncorrectException('Password lama tidak cocok!');
    }

    // Validate new password and confirmation
    if (newPassword.value == confirmPassword.value) {
      box.write('password', newPassword.value);
      print('Password updated from $storedPassword to ${newPassword.value}');

      Get.snackbar('Sukses', 'Password berhasil diperbarui!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      // Clear the password fields after successful update
      oldPassword.value = ''; // Clear old password field
      newPassword.value = ''; // Clear new password field
      confirmPassword.value = ''; // Clear confirm password field
    } else {
      throw PasswordMismatchException('Password baru dan konfirmasi tidak sama!');
    }
  }
}
