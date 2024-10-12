import 'package:get/get.dart';
import 'package:flutter/material.dart';

class JournalController extends GetxController {
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var selectedCategory = ''.obs; // Pastikan diinisialisasi
  var categories = <String>['Kategori 1', 'Kategori 2', 'Kategori 3'].obs; // Contoh kategori
  var journalEntries = <Map<String, String>>[].obs; // Entri jurnal yang akan ditampilkan

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi nilai default jika diperlukan
    startDateController.text = 'Pilih Tanggal Awal';
    endDateController.text = 'Pilih Tanggal Akhir';
  }

  void selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      if (isStartDate) {
        startDateController.text = formattedDate;
      } else {
        endDateController.text = formattedDate;
      }
    }
  }

  void onCategorySelected(String value) {
    selectedCategory.value = value;
  }

  void showGraph() {
    // Logika untuk menampilkan grafik
  }
}
