import 'package:get/get.dart';

class ProductController extends GetxController {
  // List of products
  final productList = [
    Product(
      image: 'lib/assets/kaos1.png',
      title: 'Kaos Heavyweight Hitam',
      price: 142000,
      description: 'Kaos heavyweight ini terbuat dari 100% katun, memberikan kenyamanan maksimal. Cocok untuk tampilan kasual sehari-hari.',
    ),
    Product(
      image: 'lib/assets/kaos2.jpg',
      title: 'Kaos Heavyweight Coklat',
      price: 150000,
      description: 'Kaos coklat ini memiliki desain klasik yang timeless, ideal untuk dipadukan dengan berbagai outfit.',
    ),
    Product(
      image: 'lib/assets/kaos3.jpg',
      title: 'Kaos Heavyweight Oversize',
      price: 102000,
      description: 'Kaos oversize ini memberikan gaya santai dan trendy, cocok untuk yang menyukai fashion yang lebih leluasa.',
    ),
    Product(
      image: 'lib/assets/kaos4.jpg',
      title: 'Kaos Heavyweight Boxy',
      price: 102000,
      description: 'Kaos boxy ini dirancang dengan potongan yang modern, memberikan tampilan stylish dan nyaman.',
    ),
  ].obs;

  var isLoading = false.obs;
}

class Product {
  final String image;
  final String title;
  final int price;
  final String description;

  var id;

  Product({
    required this.image,
    required this.title,
    required this.price,
    required this.description,
  });
}
