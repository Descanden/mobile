import 'package:get/get.dart';

class PasswordManagerController extends GetxController {
  final oldPasswordController = ''.obs;
  final newPasswordController = ''.obs;

  void updatePassword(String oldPassword, String newPassword) {
    // Tambahkan logika untuk memperbarui password di sini
    if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
      // Lakukan operasi update password
      print('Password diperbarui dari $oldPassword ke $newPassword');
    } else {
      print('Pastikan semua field telah terisi.');
    }
  }
}
