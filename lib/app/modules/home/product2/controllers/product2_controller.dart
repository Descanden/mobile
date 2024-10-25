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