import 'package:get/get.dart';

class BasketController extends GetxController {
  // Observable list to store items in the basket
  final items = <Map<String, dynamic>>[].obs;
  final allSelected = false.obs;
  final selectedTotal = 0.obs;
  final selectedCount = 0.obs;

  void addItem(Map<String, dynamic> item) {
    // Add item to the basket with a default selection state
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

    // Set the selection state of all items
    for (var item in items) {
      item['selected'] = newValue;
    }

    calculateSelectedTotal();
  }

  void calculateSelectedTotal() {
    int total = 0;
    int count = 0;

    // Calculate the total price and count of selected items
    for (var item in items) {
      if (item['selected']) {
        // Ensure prices and quantities are treated as integers
        total += (item['product']['price'] as num).toInt() * (item['quantity'] as num).toInt();
        count += (item['quantity'] as num).toInt();
      }
    }

    selectedTotal.value = total;
    selectedCount.value = count;
  }

  void checkout() {
    // Handle checkout with selected items
    // You can implement your checkout logic here
  }
}
