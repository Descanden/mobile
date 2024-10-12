import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pegawai/controllers/pegawai_controller.dart';

class EditPegawaiController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var namaPegawai = ''.obs;
  var nomorTelepon = ''.obs;
  var role = ''.obs;
  var status = ''.obs;

  final PegawaiController pegawaiController = Get.find<PegawaiController>();

  // Menyiapkan detail pegawai yang ingin diedit
  void setPegawaiDetails(String username, String password, String namaPegawai, String nomorTelepon, String role, String status) {
    this.username.value = username;
    this.password.value = password;
    this.namaPegawai.value = namaPegawai;
    this.nomorTelepon.value = nomorTelepon;
    this.role.value = role;
    this.status.value = status;
  }

  // Logika untuk mengupdate pegawai
  void updatePegawai(Pegawai pegawai) {
    // Flag untuk mendeteksi perubahan
    bool updated = false;

    // Validasi bahwa semua kolom harus diisi
    if (username.value.isEmpty || password.value.isEmpty || namaPegawai.value.isEmpty || nomorTelepon.value.isEmpty || role.value.isEmpty || status.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua kolom harus diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Memeriksa apakah ada perubahan
    if (pegawai.username != username.value) {
      pegawai.username = username.value;
      updated = true;
    }
    if (pegawai.password != password.value) {
      pegawai.password = password.value;
      updated = true;
    }
    if (pegawai.name != namaPegawai.value) {
      pegawai.name = namaPegawai.value;
      updated = true;
    }
    if (pegawai.phone != nomorTelepon.value) {
      pegawai.phone = nomorTelepon.value;
      updated = true;
    }
    if (pegawai.role != role.value) {
      pegawai.role = role.value;
      updated = true;
    }
    if (pegawai.status != status.value) {
      pegawai.status = status.value;
      updated = true;
    }

    // Melakukan update jika ada perubahan
    if (updated) {
      // Panggil metode update dari PegawaiController
      pegawaiController.updatePegawai(pegawai.username, pegawai.password, pegawai.name, pegawai.phone, pegawai.role, pegawai.status);
      Get.snackbar(
        'Sukses',
        'Data pegawai berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Info',
        'Tidak ada perubahan untuk disimpan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Konfirmasi penghapusan pegawai
  void showDeleteConfirmation(Pegawai pegawai) {
    Get.defaultDialog(
      title: 'Konfirmasi Hapus',
      middleText: 'Apakah Anda yakin ingin menghapus pegawai ini?',
      onConfirm: () {
        pegawaiController.deletePegawai(pegawai);
        Get.back(); // Tutup dialog konfirmasi
      },
      onCancel: () {
        Get.back(); // Tutup dialog dan tetap di halaman ini
      },
      barrierDismissible: false,
      cancel: ElevatedButton(
        onPressed: () {
          Get.back(); // Menutup dialog
        },
        child: const Text('Batal'),
      ),
    );
  }
}
