import 'package:get/get.dart';

class HistoryController extends GetxController {
  // Manage search query and list of history data
  var searchQuery = ''.obs;
  var historyData = <HistoryItem>[
    HistoryItem(name: 'Irvan s.', date: '2 Mei 2024', total: 64500, status: 'Status'),
    HistoryItem(name: 'Rofiq', date: '2 Mei 2024', total: 640500, status: 'Cash'),
    HistoryItem(name: 'Rekta', date: '2 Juli 2024', total: 4500, status: 'VA'),
    HistoryItem(name: 'Rekta', date: '2 Juli 2024', total: 4500, status: 'Pending'),
  ].obs;

  // Filter history based on search query
  List<HistoryItem> get filteredHistory => historyData.where((item) {
    return item.name.toLowerCase().contains(searchQuery.value.toLowerCase());
  }).toList();

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}

class HistoryItem {
  final String name;
  final String date;
  final int total;
  final String status;

  HistoryItem({required this.name, required this.date, required this.total, required this.status});
}
