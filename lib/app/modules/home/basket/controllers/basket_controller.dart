import 'package:get/get.dart';

class BasketController extends GetxController {
  final items = <Map<String, dynamic>>[].obs;
  final allSelected = false.obs;
  final selectedTotal = 0.obs;
  final selectedCount = 0.obs;

  void addItem(Map<String, dynamic> item) { 
    items.add({...item, 'selected': false});
    calculateSelectedTotal();
  }

  void increaseQuantity(int index) {
    items[index]['quantity']++;
    calculateSelectedTotal();
  }

  void decreaseQuantity(int index) {
    if (items[index]['quantity'] > 1) {
      items[index]['quantity']--;
      calculateSelectedTotal();
    }
  }

  void toggleItemSelection(int index) {
    items[index]['selected'] = !items[index]['selected'];
    calculateSelectedTotal();
    allSelected.value = items.every((item) => item['selected']);
  }

  void toggleSelectAll() {
    final newValue = !allSelected.value;
    allSelected.value = newValue;
    for (var item in items) {
      item['selected'] = newValue;
    }
    calculateSelectedTotal();
  }

  void calculateSelectedTotal() {
    int total = 0;
    int count = 0;
    for (var item in items) {
      if (item['selected']) {
        // Explicitly casting and converting to int
        total += (item['product']['price'] is num ? (item['product']['price'] as num).toInt() : 0) * (item['quantity'] is num ? (item['quantity'] as num).toInt() : 1);
        count += (item['quantity'] is num ? (item['quantity'] as num).toInt() : 1);
      }
    }
    selectedTotal.value = total;
    selectedCount.value = count;
  }

  void checkout() {
    // Handle checkout with selected items
  }
}
