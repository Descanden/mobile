import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class Product2Controller extends GetxController {
  var productList = <Product>[].obs; // Observable list of products
  var isLoading = true.obs;          // Observable for loading state
  var hasError = false.obs;          // Observable for error state

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity(); // Connectivity instance

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Fetch products on initialization

    // Listen for connectivity changes and reload data when internet is available
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        fetchProducts(); // Reload products when internet is available
      }
    });
  }

  // Fetch products from Firestore for Product2 category
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;  // Show loading indicator
      hasError.value = false; // Reset error state
      
      var querySnapshot = await _firestore.collection('products2').get();

      // Map Firestore documents to Product objects
      var products = querySnapshot.docs.map((doc) {
        return Product(
          image: doc['image'],
          title: doc['title'],
          price: doc['price'],
          description: doc['description'],
        );
      }).toList();

      // Save the fetched products to SharedPreferences
      await saveProductsToLocalStorage(products);

      productList.assignAll(products); // Update product list
    } catch (e) {
      hasError.value = true; // Set error state
      print("Error fetching products: $e");

      // Load products from local storage if error occurs
      loadProductsFromLocalStorage();
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  // Save products to SharedPreferences
  Future<void> saveProductsToLocalStorage(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productStrings = products.map((product) => product.toJson()).toList();
    await prefs.setStringList('products2', productStrings); // Save products as a list of JSON strings
  }

  // Load products from SharedPreferences
  Future<void> loadProductsFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? productStrings = prefs.getStringList('products2');
    
    if (productStrings != null) {
      List<Product> products = productStrings.map((str) => Product.fromJson(str)).toList();
      productList.assignAll(products); // Load products from local storage
    } else {
      hasError.value = true; // Set error state if no data in SharedPreferences
    }
  }

  // Example function to add a product (implementation optional)
  void addProduct(Product newProduct2) {
    productList.add(newProduct2);
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

  // Convert Product to JSON string
  String toJson() {
    return '{"image": "$image", "title": "$title", "price": $price, "description": "$description"}';
  }

  // Convert JSON string back to Product
  factory Product.fromJson(String json) {
    final Map<String, dynamic> data = jsonDecode(json);
    return Product(
      image: data['image'],
      title: data['title'],
      price: data['price'],
      description: data['description'],
    );
  }
}
