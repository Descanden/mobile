import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Product2Controller extends GetxController {
  var productList = <Product>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Fetch products when the controller is initialized
  }

  // Fetch products from Firestore for Product2 category
  void fetchProducts() async {
    try {
      var querySnapshot = await _firestore.collection('products2').get();
      var products = querySnapshot.docs.map((doc) {
        return Product(
          image: doc['image'],
          title: doc['title'],
          price: doc['price'],
          description: doc['description'],
        );
      }).toList();
      productList.assignAll(products); // Update product list
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  void addProduct(Product newProduct2) {}
}

class Product {
  final String image;
  final String title;
  final int price;
  final String description;

  Product({required this.image, required this.title, required this.price, required this.description});
}
