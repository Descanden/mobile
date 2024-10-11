import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../supplier/controllers/supplier_controller.dart';

class EditSupplierController extends GetxController {
  var name = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var description = ''.obs;

  final SupplierController supplierController = Get.find<SupplierController>();

  void setSupplierDetails(String name, String phone, String address, String description) {
    this.name.value = name;
    this.phone.value = phone;
    this.address.value = address;
    this.description.value = description;
  }

  void showDeleteConfirmation(Supplier supplier) {
    Get.defaultDialog(
      title: 'Konfirmasi Hapus',
      middleText: 'Apakah Anda yakin ingin menghapus supplier ini?',
      onConfirm: () {
        supplierController.deleteSupplier(supplier);
        Get.back(); // Tutup dialog konfirmasi
        Get.back(); // Kembali ke halaman sebelumnya
      },
      onCancel: () {
        Get.back(); // Tutup dialog dan tetap di halaman ini
      },
      barrierDismissible: false,
      cancel: ElevatedButton(
        onPressed: () {
          Get.back(); // Hide the confirmation dialog
        },
        child: const Text('Batal'),
      ),
    );
  }

  void updateSupplier(Supplier supplier) {
    // Flag untuk mendeteksi perubahan
    bool updated = false;

    // Validasi bahwa semua kolom harus diisi
    if (name.value.isEmpty || phone.value.isEmpty || address.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua kolom harus diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Memeriksa apakah ada perubahan
    if (supplier.name != name.value) {
      supplier.name = name.value;
      updated = true;
      Get.snackbar('Berhasil', 'Nama Supplier berhasil diperbarui.');
    }
    if (supplier.phone != phone.value) {
      supplier.phone = phone.value;
      updated = true;
      Get.snackbar('Berhasil', 'No. Telepon berhasil diperbarui.');
    }
    if (supplier.address != address.value) {
      supplier.address = address.value;
      updated = true;
      Get.snackbar('Berhasil', 'Alamat berhasil diperbarui.');
    }
    if (supplier.description != description.value) {
      supplier.description = description.value;
      updated = true;
      Get.snackbar('Berhasil', 'Deskripsi berhasil diperbarui.');
    }

    // Melakukan update jika ada perubahan
    if (updated) {
      // Panggil metode update dari SupplierController
      supplierController.updateSupplier(supplier); 
      Get.snackbar(
        'Sukses',
        'Supplier berhasil diperbarui.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back(); // Kembali ke halaman sebelumnya
    } else {
      Get.snackbar(
        'Info',
        'Tidak ada perubahan untuk disimpan.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
