import 'package:get/get.dart';

class ProductController extends GetxController {
  // List of products
  final productList = [
    Product(
      image: 'lib/assets/bomber1.jpg',
      title: 'Cotton Bomber Jacket',
      price: 142000,
      description: 'Premium Fabric:The light bomber jacket for men with the premium linen fabric for providing you the best feeling and comfort.',
    ),
    Product(
      image: 'lib/assets/bomber2.jpeg',
      title: 'Hero Matte Classic Bomber Jacket',
      price: 150000,
      description: 'Engineered for weather protection, this Calvin Klein matte bomber jacket is crafted from recycled polyester with wind and water-resistance. Cut in a classic fit with a full zip closure, a Calvin Klein logo at the back and PrimaLoft® insulation. Finished with raised ottoman stitching and ribbed knit trim for a close, snug fit.',
    ),
    Product(
      image: 'lib/assets/bomber3.jpeg',
      title: 'Armored Bomber Jacket',
      price: 102000,
      description: 'The perfect complement to throw over a T-shirt or jumper, this bomber jacket is padded with 100% recycled polyester fill for warmth and the waxed cotton canvas shell is water repellent and abrasion resistant. Wear all day on and off your bike.',
    ),
    Product(
      image: 'lib/assets/bomber5.webp',
      title: 'Everyday Bomber Jacket',
      price: 102000,
      description: 'The classic design is made with 2 outside side pockets, and 3 internal pockets, 1 classic internal pocket, 1 internal patch pocket and a lower left hand pocket.',
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
