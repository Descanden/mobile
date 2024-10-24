import 'package:get/get.dart';
import '../../product/controllers/product_controller.dart'; // Import the Product model from components

class Product2Controller extends GetxController {
  final productList = <Product>[].obs; // Observable list of Product for Product2
  var isLoading = false.obs;

  // Initial list of products
  @override
  void onInit() {
    super.onInit();
    loadInitialProducts(); // Load initial products
  }

  void loadInitialProducts() {
    productList.addAll([
      Product(
        image: 'lib/assets/hw3.jpeg',
        title: 'Kaos Heavyweight Hitam',
        price: 142000,
        description: 'Kaos heavyweight ini terbuat dari 100% katun, memberikan kenyamanan maksimal. Cocok untuk tampilan kasual sehari-hari.',
      ),
      Product(
        image: 'lib/assets/hw4.jpeg',
        title: 'Kaos Heavyweight Coklat',
        price: 150000,
        description: 'Kaos coklat ini memiliki desain klasik yang timeless, ideal untuk dipadukan dengan berbagai outfit.',
      ),
      Product(
        image: 'lib/assets/hw1.jpg',
        title: 'Kaos Heavyweight Oversize',
        price: 102000,
        description: 'Kaos oversize ini memberikan gaya santai dan trendy, cocok untuk yang menyukai fashion yang lebih leluasa.',
      ),
      Product(
        image: 'lib/assets/hw2.jpeg',
        title: 'Kaos Heavyweight Boxy',
        price: 102000,
        description: 'Kaos boxy ini dirancang dengan potongan yang modern, memberikan tampilan stylish dan nyaman.',
      ),
    ]);
  }

  // Method to add a new product to the productList
  void addProduct(Product product) {
    productList.add(product);
    Get.snackbar("Success", "Product added to Product2 successfully!");
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