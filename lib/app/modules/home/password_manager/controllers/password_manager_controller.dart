import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PasswordMismatchException implements Exception {
  final String message;
  PasswordMismatchException(this.message);
}
 
class PasswordManagerController extends GetxController {
  var oldPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  final box = GetStorage();

  @override
  void onInit() {
    oldPassword.value = box.read('password') ?? '';
    super.onInit();
  }

  void updatePassword() {
    if (oldPassword.isNotEmpty && newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
      if (newPassword.value == confirmPassword.value) {
        box.write('password', newPassword.value);
        print('Password updated from ${oldPassword.value} to ${newPassword.value}');
        
        Get.snackbar('Sukses', 'Password berhasil diperbarui!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
        
        oldPassword.value = newPassword.value;
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
