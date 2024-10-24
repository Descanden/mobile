import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pemrograman_mobile/app/modules/home/product3/controllers/product3_controller.dart';

Future<void> _addProduct(dynamic titleController, dynamic descriptionController, dynamic priceController, dynamic productController, dynamic product2Controller) async {
  String title = titleController.text;
  int price = int.tryParse(priceController.text) ?? 0;
  String description = descriptionController.text;

  // Menyimpan ke Firestore
  CollectionReference productsRef = FirebaseFirestore.instance.collection('products');
  
  var selectedCategory;
  await productsRef.add({
    'title': title,
    'price': price,
    'description': description,
    'image': 'lib/assets/default_image.png', // Ganti dengan gambar yang relevan
    'category': selectedCategory,
  });

  // Tambahkan produk ke dalam controller sesuai kategori
  if (selectedCategory == 'Category1') {
    productController.productList.add(Product(
      image: 'lib/assets/default_image.png',
      title: title,
      price: price,
      description: description,
    ));
  } else if (selectedCategory == 'Category2') {
    product2Controller.productList.add(Product(
      image: 'lib/assets/default_image.png',
      title: title,
      price: price,
      description: description,
    ));
  }

  // Kembali ke halaman sebelumnya
  Get.back();
}
