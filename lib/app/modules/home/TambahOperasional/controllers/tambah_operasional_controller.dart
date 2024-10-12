import 'package:get/get.dart';
import '../../Operasional/controllers/operasional_controller.dart';

class TambahOperasionalController extends GetxController {
  var selectedKategori = ''.obs;
  var selectedPembayaran = ''.obs;
  var nilaiRp = ''.obs;
  var keterangan = ''.obs;
  var tanggal = ''.obs;
  var fileNota = ''.obs;

  // Pilih kategori pengeluaran
  void pilihKategori(String kategori) {
    selectedKategori.value = kategori;
  }

  // Pilih metode pembayaran
  void pilihPembayaran(String pembayaran) {
    selectedPembayaran.value = pembayaran;
  }

  // Fungsi untuk memilih gambar (simulasi)
  void pilihGambar() {
    // Di sini Anda dapat menambahkan logika untuk memilih gambar
    fileNota.value = 'path/to/nota.jpg'; // Contoh pemilihan gambar
  }

  // Fungsi untuk menyimpan data
  void simpanOperasional() {
    // Validasi input
    if (selectedKategori.value.isNotEmpty &&
        nilaiRp.value.isNotEmpty &&
        keterangan.value.isNotEmpty &&
        tanggal.value.isNotEmpty) {
      // Mengambil nilai dari observables
      final expenseType = selectedKategori.value;
      final expenseAmount = int.tryParse(nilaiRp.value) ?? 0;
      final expenseDate = tanggal.value;
      final expenseDescription = keterangan.value;
      final expenseImage = fileNota.value;

      // Tambahkan pengeluaran ke controller utama
      Get.find<OperasionalController>().addExpense(
        expenseDescription, // Keterangan
        expenseAmount,      // Nilai
        expenseDate         // Tanggal
      );

      Get.back(); // Kembali ke halaman sebelumnya

      // Menampilkan snackbar sebagai konfirmasi
      Get.snackbar('Sukses', 'Pengeluaran berhasil disimpan.',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Semua field harus diisi!',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
