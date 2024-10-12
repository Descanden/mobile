import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pegawai/controllers/pegawai_controller.dart';

class TambahPegawaiController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController addressController = TextEditingController(); // Tambahan untuk address
  final TextEditingController descriptionController = TextEditingController(); // Tambahan untuk description

  var selectedPegawaiRole = 'Admin'.obs; // Default role
  var selectedStatus = 'Active'.obs; // Default status

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    namaController.dispose();
    nomorController.dispose();
    addressController.dispose(); // Dispose addressController
    descriptionController.dispose(); // Dispose descriptionController
    super.onClose();
  }

  void addPegawai(PegawaiController pegawaiController) {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();
    final String nama = namaController.text.trim();
    final String nomor = nomorController.text.trim();
    final String address = addressController.text.trim();
    final String description = descriptionController.text.trim();
    final String role = selectedPegawaiRole.value;
    final String status = selectedStatus.value;

    if (username.isNotEmpty && password.isNotEmpty && nama.isNotEmpty && nomor.isNotEmpty && address.isNotEmpty && description.isNotEmpty) {
      pegawaiController.addPegawai(username, password, nama, nomor, address, description, role, status);

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
    addressController.clear();
    descriptionController.clear();
    selectedPegawaiRole.value = 'Admin'; // Reset to default
    selectedStatus.value = 'Active'; // Reset to default
  }
}
