import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'dart:io'; // File handling
import '../../product/controllers/product_controller.dart' as HomeProduct;
import '../../product2/controllers/product2_controller.dart' as Product2;
import '../../product3/controllers/product3_controller.dart' as Product3;

class ItemController extends GetxController {
  var categories = <String>[].obs; // Observable list of categories
  var selectedCategory = ''.obs; // Selected category
  final nameController = TextEditingController(); // Controller for product name
  final priceController = TextEditingController(); // Controller for price
  final descriptionController = TextEditingController(); // Controller for description
  XFile? image; // For holding the selected image

  var isLoading = false.obs; // Observable for loading state

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
      'Product3',
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
      print("Error picking image: $e");
    }
  }

  // Function to upload image to Firebase Storage and get the download URL
  Future<String?> uploadImageToFirebaseStorage(XFile imageFile) async {
    try {
      String fileName = 'products/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      Reference ref = _firebaseStorage.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(File(imageFile.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
      return null;
    }
  }

  // Function to save the item
  Future<void> saveItem() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedCategory.value.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    print("Selected category: ${selectedCategory.value}");

    String? imageUrl;
    if (image != null) {
      isLoading.value = true; // Set loading state to true
      imageUrl = await uploadImageToFirebaseStorage(image!);
      if (imageUrl == null) {
        Get.snackbar("Error", "Failed to upload image");
        isLoading.value = false; // Set loading state to false
        return;
      }
    } else {
      imageUrl = '';
    }

    var newProduct = Product3.Product(
      image: imageUrl,
      title: nameController.text,
      price: int.tryParse(priceController.text) ?? 0,
      description: descriptionController.text, // Use descriptionController text
    );

    try {
      if (selectedCategory.value == 'Product1') {
        final productController = Get.find<HomeProduct.ProductController>();
        var homeProduct = HomeProduct.Product(
          image: imageUrl,
          title: nameController.text,
          price: int.tryParse(priceController.text) ?? 0,
          description: descriptionController.text,
        );
        productController.productList.add(homeProduct);

        await _firestore.collection('products1').add({
          'image': imageUrl,
          'title': homeProduct.title,
          'price': homeProduct.price,
          'description': homeProduct.description,
        });

        Get.snackbar("Success", "Product added to Product1 successfully!");
      } else if (selectedCategory.value == 'Product2') {
        final product2Controller = Get.find<Product2.Product2Controller>();
        var newProduct2 = Product2.Product(
          image: imageUrl,
          title: nameController.text,
          price: int.tryParse(priceController.text) ?? 0,
          description: descriptionController.text,
        );
        product2Controller.addProduct(newProduct2);

        await _firestore.collection('products2').add({
          'image': newProduct2.image,
          'title': newProduct2.title,
          'price': newProduct2.price,
          'description': newProduct2.description,
        });

        Get.snackbar("Success", "Product added to Product2 successfully!");
      } else if (selectedCategory.value == 'Product3') {
        final product3Controller = Get.find<Product3.Product3Controller>();
        product3Controller.productList.add(newProduct);

        await _firestore.collection('products3').add({
          'image': newProduct.image,
          'title': newProduct.title,
          'price': newProduct.price,
          'description': newProduct.description,
        });

        Get.snackbar("Success", "Product added to Product3 successfully!");
      } else {
        Get.snackbar("Error", "Invalid category selected");
        isLoading.value = false;
        return;
      }
    } catch (e) {
      print("Error saving product: $e");
      Get.snackbar("Error", "Failed to save product");
    } finally {
      isLoading.value = false; // Set loading state to false
    }

    // Clear fields and reset state
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    image = null;
    selectedCategory.value = '';
    update(); // Update UI
  }
}
