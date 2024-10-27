import 'package:get/get.dart';

class BasketController extends GetxController {
  final items = <Map<String, dynamic>>[].obs;

  void addItem(Map<String, dynamic> item) {
    items.add(item);
  }

  int get totalItems => items.length;
}
