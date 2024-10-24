import 'package:get/get.dart';

class ProductController extends GetxController {
  final productList = <Product>[].obs; // List of products (use observable list)

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
