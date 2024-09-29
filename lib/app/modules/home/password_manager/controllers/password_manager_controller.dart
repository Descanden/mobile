import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import '../controllers/password_manager_controller.dart';

class PasswordMismatchException implements Exception {
  final String message;
  PasswordMismatchException(this.message);
}

class PasswordManagerController extends GetxController {
  var oldPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  void updatePassword() {
    if (oldPassword.isNotEmpty && newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
      if (newPassword.value == confirmPassword.value) {
        // Logika untuk memperbarui password
        print('Password diperbarui dari ${oldPassword.value} ke ${newPassword.value}');
        // Notifikasi sukses
        Get.snackbar('Sukses', 'Password berhasil diperbarui!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        throw PasswordMismatchException('Password baru dan konfirmasi tidak sama!');
      }
    } else {
      Get.snackbar('Error', 'Pastikan semua field telah terisi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
