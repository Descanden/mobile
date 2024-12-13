import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Product3Controller extends GetxController {
  var productList = <Product>[].obs; // Observable list of products
  var isLoading = true.obs;          // Loading state
  var hasError = false.obs;          // Error state

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity(); // Connectivity instance

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Fetch products on initialization
    _setupConnectivityListener(); // Set up listener for connectivity changes
  }

  // Set up a connectivity listener
  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        // Internet is available, fetch products
        print("Internet reconnected. Reloading data...");
        fetchProducts();
      } else {
        // Internet is not available
        hasError.value = true;
        print("No internet connection.");
      }
    });
  }

  // Function to fetch products from Firestore
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true; // Show loading indicator
      hasError.value = false; // Reset error state

      var querySnapshot = await _firestore.collection('products3').get();
      if (querySnapshot.docs.isNotEmpty) {
        productList.value = querySnapshot.docs.map((doc) {
          return Product(
            image: doc['image'],
            title: doc['title'],
            price: doc['price'],
            description: doc['description'],
          );
        }).toList();
      } else {
        productList.clear(); // Clear list if no products are found
      }
    } catch (e) {
      hasError.value = true; // Set error state
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
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
