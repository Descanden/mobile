import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pegawai/controllers/pegawai_controller.dart';

class TambahPegawaiController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();

  var selectedPegawaiRole = 'Admin'.obs; // Default role
  var selectedStatus = 'Active'.obs; // Default status

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    namaController.dispose();
    nomorController.dispose();
    super.onClose();
  }

  void addPegawai(PegawaiController pegawaiController) {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();
    final String nama = namaController.text.trim();
    final String nomor = nomorController.text.trim();
    final String role = selectedPegawaiRole.value;
    final String status = selectedStatus.value;

    if (username.isNotEmpty && password.isNotEmpty && nama.isNotEmpty && nomor.isNotEmpty) {
      pegawaiController.addPegawai(username, password, nama, nomor, role, status);

      // Clear inputs after adding
      clearInputs();

      Get.snackbar('Sukses', 'Pegawai berhasil ditambahkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } else {
      Get.snackbar('Error', 'Semua kolom harus diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void clearInputs() {
    usernameController.clear();
    passwordController.clear();
    namaController.clear();
    nomorController.clear();
    selectedPegawaiRole.value = 'Admin'; // Reset to default
    selectedStatus.value = 'Active'; // Reset to default
  }
}
