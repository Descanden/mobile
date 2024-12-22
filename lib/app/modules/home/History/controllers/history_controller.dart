import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController {
  var searchQuery = ''.obs;
  var historyData = <HistoryItem>[].obs;
  var filteredHistory = <HistoryItem>[].obs;

  final GetStorage box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadHistoryData();
  }

  void loadHistoryData() {
    // Load data from GetStorage and cast it correctly
    var savedHistory = box.read('checkoutHistory') ?? [];
    if (savedHistory is List) {
      historyData.value = savedHistory.map((item) {
        // Ensure that the item is a Map<String, dynamic>
        if (item is Map<String, dynamic>) {
          return HistoryItem(
            name: item['name'] ?? 'Unknown', // Name can be the address or recipient name
            date: item['date'] ?? 'Unknown',
            total: item['total'] ?? 0,
            status: item['status'] ?? 'Pending',
          );
        } else {
          // If item is not a Map, return a default HistoryItem
          return HistoryItem(
            name: 'Unknown',
            date: 'Unknown',
            total: 0,
            status: 'Pending',
          );
        }
      }).toList();
    }
    filteredHistory.value = historyData;
  }

  // Filter history based on search query
  List<HistoryItem> get filteredSearchHistory {
    return historyData.where((item) {
      return item.name.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    filteredHistory.value = filteredSearchHistory;
  }

  // Filter history for monthly view (e.g., May)
  void filterMonthly() {
    filteredHistory.value = historyData.where((item) {
      final itemMonth = DateTime.parse('${item.date.split(' ')[1]} 1, 2024').month; // Convert date to DateTime and get the month
      final currentMonth = DateTime.now().month; // Get current month
      return itemMonth == currentMonth;
    }).toList();
  }

  // Filter history for daily view (e.g., today)
  void filterDaily() {
    filteredHistory.value = historyData.where((item) {
      final itemDate = DateTime.parse('${item.date.split(' ')[1]} ${item.date.split(' ')[0]}, 2024');
      final currentDate = DateTime.now();
      return itemDate.year == currentDate.year &&
          itemDate.month == currentDate.month &&
          itemDate.day == currentDate.day;
    }).toList();
  }
}

class HistoryItem {
  final String name;
  final String date;
  final int total;
  final String status;

  HistoryItem({required this.name, required this.date, required this.total, required this.status});
}
