import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../../product/controllers/product_controller.dart' as HomeProduct; // Alias for home product controller
import '../../product2/controllers/product2_controller.dart' as Product2; // Alias for product2 controller
import '../../product3/controllers/product3_controller.dart' as Product3; // Alias for product3 controller

class ItemController extends GetxController {
  var categories = <String>[].obs; // Observable list of categories
  var selectedCategory = ''.obs; // Selected category
  final nameController = TextEditingController(); // Controller for product name
  final priceController = TextEditingController(); // Controller for price
  final sizeController = TextEditingController(); // Controller for size
  XFile? image; // For holding the selected image

  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  @override
  void onInit() {
    super.onInit();
    fetchCategories(); // Fetch categories when the controller is initialized
  }

  // Simulate fetching categories from a database or API
  void fetchCategories() {
    categories.value = [
      'Product1',
      'Product2',
      'Product3'
    ]; // Use proper capitalization for consistency
  }

  // Function to pick an image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        update(); // Notify the UI to update when an image is picked
      }
    } catch (e) {
      // Handle errors if needed
      print("Error picking image: $e");
    }
  }

  // Function to save the item
  Future<void> saveItem() async {
    // Check that required fields are filled
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedCategory.value.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    // Create a new product for the selected category
    var newProduct = Product3.Product(
      image: image?.path ?? '', // Image path (ensure you save the image correctly)
      title: nameController.text,
      price: int.tryParse(priceController.text) ?? 0, // Parse price to int
      description: "Description for ${nameController.text}", // A default description; you can change this
    );

    // Determine which product controller to use based on selected category
    if (selectedCategory.value == 'Product1') {
      // Add product to ProductController
      final productController = Get.find<HomeProduct.ProductController>(); // Use the alias
      var homeProduct = HomeProduct.Product(
        image: image?.path ?? '',
        title: nameController.text,
        price: int.tryParse(priceController.text) ?? 0,
        description: "Description for ${nameController.text}",
      );
      productController.productList.add(homeProduct);
      Get.snackbar("Success", "Product added to Product1 successfully!");
    } else if (selectedCategory.value == 'Product2') {
      // Add product to Product2Controller
      final product2Controller = Get.find<Product2.Product2Controller>(); // Use the alias
      product2Controller.addProduct(newProduct as Product2.Product); // Use the Product2 product directly

      // Save the product to Firestore
      await _firestore.collection('products2').add({
        'image': newProduct.image,
        'title': newProduct.title,
        'price': newProduct.price,
        'description': newProduct.description,
      });

      Get.snackbar("Success", "Product added to Product2 successfully!");
    } else if (selectedCategory.value == 'Product3') {
      // Add product to Product3Controller
      final product3Controller = Get.find<Product3.Product3Controller>(); // Use the alias
      product3Controller.productList.add(newProduct); // Add new product to Product3
  
      // Save the product to Firestore (if needed for Product3)
      await _firestore.collection('products3').add({
        'image': newProduct.image,
        'title': newProduct.title,
        'price': newProduct.price,
        'description': newProduct.description,
      });

      Get.snackbar("Success", "Product added to Product3 successfully!");
    } else {
      Get.snackbar("Error", "Invalid category selected");
      return;
    }

    // Clear fields
    nameController.clear();
    priceController.clear();
    sizeController.clear();
    image = null; // Clear the image
    selectedCategory.value = ''; // Reset selected category
    update(); // Update the UI
  }
}
