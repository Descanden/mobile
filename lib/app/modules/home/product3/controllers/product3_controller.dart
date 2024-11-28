import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Product3Controller extends GetxController {
  var productList = <Product>[].obs; // Observable list of products

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Fetch products when the controller is initialized
  }

  // Function to fetch products from Firestore
  Future<void> fetchProducts() async {
    try {
      var querySnapshot = await _firestore.collection('products3').get();
      productList.value = querySnapshot.docs.map((doc) {
        return Product(
          image: doc['image'],
          title: doc['title'],
          price: doc['price'],
          description: doc['description'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching products: $e");
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
