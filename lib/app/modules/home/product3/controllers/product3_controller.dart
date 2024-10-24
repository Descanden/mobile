import 'package:get/get.dart';

class Product3Controller extends GetxController {
  var productList = <Product>[].obs; // Observable list of products

  // Function to add a new product to the productList
  void addProduct(Product product) {
    productList.add(product);
  }
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
