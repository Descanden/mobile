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

  final PegawaiController pegawaiController = Get.find<PegawaiController>();

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    namaController.dispose();
    nomorController.dispose();
    super.onClose();
  }

  void addPegawai() {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();
    final String nama = namaController.text.trim();
    final String nomor = nomorController.text.trim();
    final String role = selectedPegawaiRole.value;
    final String status = selectedStatus.value;

    if (username.isEmpty || password.isEmpty || nama.isEmpty || nomor.isEmpty) {
      Get.snackbar('Error', 'Semua kolom harus diisi.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    pegawaiController.addPegawai(username, password, nama, nomor, role, status);
    Get.back(); // Kembali ke halaman sebelumnya setelah menambah pegawai
  }
}
