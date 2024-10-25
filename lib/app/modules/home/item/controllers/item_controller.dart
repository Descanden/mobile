import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'dart:io'; // For file handling
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
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance; // Firebase Storage instance

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

  // Function to upload image to Firebase Storage and get the download URL
  Future<String?> uploadImageToFirebaseStorage(XFile imageFile) async {
    try {
      // Create a unique file path in Firebase Storage
      String fileName = 'products/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      Reference ref = _firebaseStorage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(File(imageFile.path));
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the image URL
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
      return null;
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

    // Debug print to check selected category
    print("Selected category: ${selectedCategory.value}");

    // Check if an image is selected
    String? imageUrl;
    if (image != null) {
      // Upload the image to Firebase Storage and get the URL
      imageUrl = await uploadImageToFirebaseStorage(image!);
      if (imageUrl == null) {
        Get.snackbar("Error", "Failed to upload image");
        return;
      }
    } else {
      imageUrl = ''; // Empty string if no image is selected
    }

    // Create a new product for the selected category
    var newProduct = Product3.Product(
      image: imageUrl, // Use uploaded image URL
      title: nameController.text,
      price: int.tryParse(priceController.text) ?? 0, // Parse price to int
      description: "Description for ${nameController.text}", // A default description
    );

    // Determine which product controller to use based on selected category
    if (selectedCategory.value == 'Product1') {
      // Add product to ProductController
      final productController = Get.find<HomeProduct.ProductController>(); // Use the alias
      var homeProduct = HomeProduct.Product(
        image: imageUrl,
        title: nameController.text,
        price: int.tryParse(priceController.text) ?? 0,
        description: "Description for ${nameController.text}",
      );
      productController.productList.add(homeProduct);

      // Save product data to Firestore
      await _firestore.collection('products1').add({
        'image': imageUrl,
        'title': homeProduct.title,
        'price': homeProduct.price,
        'description': homeProduct.description,
      });

      Get.snackbar("Success", "Product added to Product1 successfully!");
    } else if (selectedCategory.value == 'Product2') {
      // Add product to Product2Controller
      final product2Controller = Get.find<Product2.Product2Controller>(); // Use the alias
      var newProduct2 = Product2.Product(
        image: imageUrl,
        title: nameController.text,
        price: int.tryParse(priceController.text) ?? 0,
        description: "Description for ${nameController.text}",
      );
      product2Controller.addProduct(newProduct2);

      // Save the product to Firestore
      await _firestore.collection('products2').add({
        'image': newProduct2.image,
        'title': newProduct2.title,
        'price': newProduct2.price,
        'description': newProduct2.description,
      });

      Get.snackbar("Success", "Product added to Product2 successfully!");
    } else if (selectedCategory.value == 'Product3') {
      // Add product to Product3Controller
      final product3Controller = Get.find<Product3.Product3Controller>(); // Use the alias
      product3Controller.productList.add(newProduct);

      // Save the product to Firestore
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
