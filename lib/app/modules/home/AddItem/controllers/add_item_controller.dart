import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'dart:typed_data';

class AddItemController extends GetxController {
  // Observable variables
  var selectedCategory = ''.obs;
  var productName = ''.obs;
  var productPrice = 0.0.obs;
  var productSize = ''.obs;
  var quantity = 1.obs;
  var productImagePath = ''.obs; // Menyimpan path dari gambar yang dipilih

  @override
  void onInit() {
    super.onInit();
    quantity.value = 1; // Default kuantitas adalah 1
  }

  // Fungsi untuk menambah gambar
  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        if (kIsWeb) {
          Uint8List? bytes = result.files.single.bytes;
          if (bytes != null) {
            String base64Image = base64Encode(bytes);
            String imageData = 'data:image/png;base64,$base64Image';
            productImagePath.value = imageData; // Menyimpan gambar dalam format base64 untuk web
          }
        } else {
          String? filePath = result.files.single.path;
          if (filePath != null) {
            productImagePath.value = filePath; // Menyimpan path gambar untuk platform mobile
          }
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  // Fungsi untuk menyimpan barang
  void saveItem() {
    if (selectedCategory.value.isEmpty ||
        productName.value.isEmpty ||
        productPrice.value <= 0 ||
        productSize.value.isEmpty ||
        quantity.value < 1 ||
        productImagePath.value.isEmpty) {
      Get.snackbar('Peringatan', 'Mohon lengkapi semua data barang.');
      return;
    }

    // Simpan data barang di sini atau lakukan aksi lainnya
    Get.snackbar('Sukses', 'Barang berhasil disimpan.');
    // Tambahkan logika untuk menyimpan data ke server atau database jika perlu
  }

}
