import 'package:get/get.dart';

class Product3Controller extends GetxController {
  final productList = <Product>[].obs;

  var isLoading = false.obs;
}

class Product {
  final String image;
  final String title;
  final int price;
  final String description;

  Product({
    required this.image,
    required this.title,
    required this.price,
    required this.description,
  });
}
  