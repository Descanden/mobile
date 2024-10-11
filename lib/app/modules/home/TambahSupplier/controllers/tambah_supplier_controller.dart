import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../supplier/controllers/supplier_controller.dart';

class TambahSupplierController extends GetxController {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  @override
  void onClose() {
    namaController.dispose();
    nomorController.dispose();
    alamatController.dispose();
    keteranganController.dispose();
    super.onClose();
  }

  void addSupplier(SupplierController supplierController) {
    final String nama = namaController.text.trim();
    final String nomor = nomorController.text.trim();
    final String alamat = alamatController.text.trim();
    final String keterangan = keteranganController.text.trim();

    if (nama.isNotEmpty && nomor.isNotEmpty && alamat.isNotEmpty) {
      supplierController.addSupplier(nama, nomor, alamat, keterangan);
      // Clear inputs after adding
      namaController.clear();
      nomorController.clear();
      alamatController.clear();
      keteranganController.clear();
      Get.snackbar('Sukses', 'Supplier berhasil ditambahkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } else {
      if (nama.isEmpty) {
        Get.snackbar('Error', 'Nama Supplier harus diisi',
            snackPosition: SnackPosition.BOTTOM);
      } else if (nomor.isEmpty) {
        Get.snackbar('Error', 'No. Telepon harus diisi',
            snackPosition: SnackPosition.BOTTOM);
      } else if (alamat.isEmpty) {
        Get.snackbar('Error', 'Alamat harus diisi',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
