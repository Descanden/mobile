import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProductController extends GetxController {
  final productList = <Product>[].obs;
  var isLoading = true.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();  // Fetch products when the controller is initialized

    // Listen for connectivity changes and reload data when internet is available
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        fetchProducts();  // Reload products when internet is available
      }
    });
  }

  // Fetch products from Firestore and add them to productList
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;  // Show loading indicator when fetching products
      var snapshot = await _firestore.collection('products1').get();  // Modify the collection name if needed
      productList.clear();
      for (var doc in snapshot.docs) {
        var data = doc.data();
        var product = Product(
          image: data['image'] ?? '',
          title: data['title'] ?? '',
          price: data['price'] ?? 0,
          description: data['description'] ?? '',
        );
        productList.add(product);
      }
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;  // Hide loading indicator after fetching data
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
