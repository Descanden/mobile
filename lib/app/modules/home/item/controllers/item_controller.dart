import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../product/controllers/product_controller.dart' as HomeProduct;
import '../../product2/controllers/product2_controller.dart' as Product2;
import '../../product3/controllers/product3_controller.dart' as Product3;

class ItemController extends GetxController {
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  XFile? image;

  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    Get.put(HomeProduct.ProductController());
    fetchCategories();
    checkOfflineData();
  }

  void fetchCategories() {
    categories.value = ['Product1', 'Product2', 'Product3'];
  }

  void checkOfflineData() async {
    List? offlineData = box.read('offlineData');
    if (offlineData != null && offlineData.isNotEmpty) {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        for (var item in offlineData) {
          await uploadProductToFirebase(item);
        }
        box.remove('offlineData');
      } else {
        Get.snackbar("Offline", "Product saved locally, waiting for connection to upload.");
      }
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        update();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

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

  Future<void> saveItem() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedCategory.value.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    String? imageUrl;
    if (image != null) {
      isLoading.value = true;
      imageUrl = await uploadImageToFirebaseStorage(image!);
      if (imageUrl == null) {
        Get.snackbar("Error", "Failed to upload image");
        isLoading.value = false;
        return;
      }
    } else {
      imageUrl = '';
    }

    var newProduct = {
      'image': imageUrl,
      'title': nameController.text,
      'price': int.tryParse(priceController.text) ?? 0,
      'description': descriptionController.text,
    };

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      List offlineData = box.read('offlineData') ?? [];
      offlineData.add(newProduct);
      box.write('offlineData', offlineData);
      Get.snackbar("Offline", "Product saved locally, will be uploaded once connected.");
    } else {
      Get.snackbar("Uploading", "Uploading your product...");
      await uploadProductToFirebase(newProduct);
    }

    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    image = null;
    selectedCategory.value = '';
    update();
  }

  Future<void> uploadProductToFirebase(Map<String, dynamic> productData) async {
    try {
      if (selectedCategory.value == 'Product1') {
        final productController = Get.find<HomeProduct.ProductController>();
        var homeProduct = HomeProduct.Product(
          image: productData['image'],
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
        );
        productController.productList.add(homeProduct);
        await _firestore.collection('products1').add(productData);
      } else if (selectedCategory.value == 'Product2') {
        final product2Controller = Get.find<Product2.Product2Controller>();
        var newProduct2 = Product2.Product(
          image: productData['image'],
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
        );
        product2Controller.addProduct(newProduct2);
        await _firestore.collection('products2').add(productData);
      } else if (selectedCategory.value == 'Product3') {
        final product3Controller = Get.find<Product3.Product3Controller>();
        var newProduct3 = Product3.Product(
          image: productData['image'],
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
        );
        product3Controller.productList.add(newProduct3);
        await _firestore.collection('products3').add(productData);
      } else {
        Get.snackbar("Error", "Invalid category selected");
        return;
      }
      Get.snackbar("Success", "Product added successfully!");
    } catch (e) {
      print("Error uploading product: $e");
      Get.snackbar("Error", "Failed to save product");
    }
  }
}
