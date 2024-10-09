import 'package:get/get.dart';

class CategoryController extends GetxController {
  // List to store product data
  final products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Add some example products to the list
    loadProducts();
  }

  void loadProducts() {
    products.value = [
      Product(
        imagePath: 'lib/assets/Photo 1 Shopping List.jpg',
        title: 'Denim Overall Shorts',
        description: 'Denim Overall Shorts adalah celana pendek berbahan denim dengan tali bahu, memberikan gaya kasual dan santai.',
      ),
      Product(
        imagePath: 'lib/assets/Photo 2 Shopping List.jpg',
        title: 'Heavyweight T-Shirt',
        description: 'Heavyweight T-Shirt adalah kaos tebal dan kuat, ideal untuk pemakaian harian.',
      ),
      Product(
        imagePath: 'lib/assets/Photo 3 Shopping List.jpg',
        title: 'Checked Coat',
        description: 'Checked Coat adalah mantel panjang bermotif kotak, ideal untuk cuaca dingin.',
      ),
    ];
  }
}

class Product {
  final String imagePath;
  final String title;
  final String description;

  Product({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
