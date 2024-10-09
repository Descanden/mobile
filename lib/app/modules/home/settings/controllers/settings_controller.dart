import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  final isDarkMode = false.obs; // Menggunakan observables (Rx)
  final box = GetStorage(); // Inisialisasi GetStorage

  @override
  void onInit() {
    // Set nilai awal dari penyimpanan lokal (true jika Dark Mode diaktifkan, false jika tidak)
    isDarkMode.value = box.read('darkMode') ?? false;
    super.onInit();
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value; // Ubah nilai Dark Mode
    Get.changeTheme(isDarkMode.value ? ThemeData.dark() : ThemeData.light()); // Ganti tema aplikasi

    // Simpan status Dark Mode ke GetStorage
    box.write('darkMode', isDarkMode.value);
  }
}
