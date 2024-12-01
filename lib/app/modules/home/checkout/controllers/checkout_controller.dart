import 'package:get/get.dart';

class CheckoutItem {
  final String name;
  final String imageUrl;
  final int price;
  final int quantity;
  final String size;

  CheckoutItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.size,
  });
}

class CheckoutController extends GetxController {
  var items = <CheckoutItem>[
    CheckoutItem(
      name: 'Nama barang',
      imageUrl: 'https://via.placeholder.com/150',
      price: 330000,
      quantity: 1,
      size: 'M',
    ),
    CheckoutItem(
      name: 'Nama barang',
      imageUrl: 'https://via.placeholder.com/150',
      price: 330000,
      quantity: 1,
      size: 'M',
    ),
  ].obs;

  int get totalPrice => items.fold(
      0, (sum, item) => sum + (item.price * item.quantity));
}
