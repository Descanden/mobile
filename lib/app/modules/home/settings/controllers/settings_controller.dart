import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:file_picker/file_picker.dart'; // Untuk pemilihan file audio

class SettingsController extends GetxController {
  final isDarkMode = false.obs; // Menggunakan observables (Rx)
  final box = GetStorage(); // Inisialisasi GetStorage
  var audioFilePath = Rx<String?>(null); // Menyimpan path audio yang dipilih

  @override
  void onInit() {
    // Set nilai awal dari penyimpanan lokal (true jika Dark Mode diaktifkan, false jika tidak)
    isDarkMode.value = box.read('darkMode') ?? false;
    audioFilePath.value = box.read('audioFilePath'); // Membaca path audio dari penyimpanan lokal
    super.onInit();
  }

  // Fungsi untuk menyimpan path audio yang dipilih
  void setAudioFilePath(String path) {
    audioFilePath.value = path;
    box.write('audioFilePath', path); // Menyimpan path ke GetStorage
  }

  // Fungsi untuk memilih file audio dari galeri/file picker
  Future<void> pickAudioFile() async {
    // Menampilkan dialog pemilihan file
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    
    if (result != null) {
      // Mendapatkan path file audio yang dipilih
      String path = result.files.single.path!;
      setAudioFilePath(path); // Menyimpan path audio yang dipilih
      Get.snackbar(
        "Audio File Selected",
        "Audio file selected: $path",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Jika tidak ada file yang dipilih
      Get.snackbar(
        "No Audio File Selected",
        "No audio file was selected.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi untuk mengubah status Dark Mode
  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value; // Ubah nilai Dark Mode
    Get.changeTheme(isDarkMode.value ? ThemeData.dark() : ThemeData.light()); // Ganti tema aplikasi

    // Simpan status Dark Mode ke GetStorage
    box.write('darkMode', isDarkMode.value);
  }
}
