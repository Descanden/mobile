import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController {
  final GetStorage box = GetStorage();
  var filteredHistory = <HistoryItem>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Memuat riwayat saat controller diinisialisasi
    loadHistory();
  }

  void loadHistory() {
    // Membaca riwayat checkout dari GetStorage
    List<Map<String, dynamic>> storedHistory = List<Map<String, dynamic>>.from(box.read('checkoutHistory') ?? []);
    
    // Mengonversi Map ke dalam objek HistoryItem
    filteredHistory.value = storedHistory.map((historyItem) {
      return HistoryItem.fromMap(historyItem);
    }).toList();

    // Menyortir filteredHistory berdasarkan tanggal (descending)
    filteredHistory.sort((a, b) => b.date.compareTo(a.date));  // Sort by date descending
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    filterHistory();
  }

  void filterHistory() {
    if (searchQuery.value.isEmpty) {
      loadHistory(); // Memuat ulang riwayat jika pencarian kosong
    } else {
      filteredHistory.value = filteredHistory.where((historyItem) {
        return historyItem.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  void addNewHistory(HistoryItem newHistory) {
    // Menambahkan data baru ke dalam riwayat yang disimpan di GetStorage
    List<Map<String, dynamic>> storedHistory = List<Map<String, dynamic>>.from(box.read('checkoutHistory') ?? []);
    storedHistory.add(newHistory.toMap()); // Menambahkan riwayat baru ke dalam daftar

    // Menyimpan kembali riwayat yang diperbarui ke GetStorage
    box.write('checkoutHistory', storedHistory);

    // Memuat ulang riwayat yang sudah diperbarui
    loadHistory();
  }

  void filterMonthly(String month) {
    // Filter history by month (parameter bulan dalam format 'YYYY-MM')
    filteredHistory.value = filteredHistory.where((historyItem) {
      return historyItem.date.startsWith(month); // Filter bulan berdasarkan parameter bulan
    }).toList();
  }

  void filterDaily(String date) {
    // Filter history by day (parameter tanggal dalam format 'YYYY-MM-DD')
    filteredHistory.value = filteredHistory.where((historyItem) {
      return historyItem.date == date; // Filter hari berdasarkan parameter tanggal
    }).toList();
  }

  void deleteHistoryEntry(HistoryItem history) {
    // Menghapus history dari list yang ada di GetStorage
    List<Map<String, dynamic>> storedHistory = List<Map<String, dynamic>>.from(box.read('checkoutHistory') ?? []);
    
    // Menghapus item berdasarkan alamat yang unik (atau ID, jika ada)
    storedHistory.removeWhere((item) => item['address'] == history.address); // Misalnya berdasarkan address
    
    // Menyimpan kembali daftar riwayat yang sudah diperbarui
    box.write('checkoutHistory', storedHistory);

    // Memuat ulang riwayat yang sudah diperbarui
    loadHistory();
  }
}

class HistoryItem {
  final String name;
  final String date;
  final double total;
  final String status;
  final String address;
  final String note;
  final List<dynamic> items;

  HistoryItem({
    required this.name,
    required this.date,
    required this.total,
    required this.status,
    required this.address,
    required this.note,
    required this.items,
  });

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      name: map['address'].split(',')[0], // Mengambil nama dari alamat
      date: map['date'],
      total: (map['total'] is int) ? (map['total'] as int).toDouble() : map['total'] as double, // Menjamin total dalam tipe double
      status: map['note'].isEmpty ? 'Pending' : 'Completed', // Menentukan status berdasarkan catatan
      address: map['address'],
      note: map['note'],
      items: map['items'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'date': date,
      'total': total,
      'note': note,
      'items': items,
    };
  }
}
