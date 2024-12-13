import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../connection/connection_controller.dart';
import '../controllers/product_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import 'dart:io';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find<SettingsController>();
    final ConnectionController connectionController = Get.find<ConnectionController>(); // Menambahkan controller koneksi

    return Obx(() {
      bool isDarkMode = settingsController.isDarkMode.value;

      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
          appBar: AppBar(
            backgroundColor: isDarkMode ? Colors.black : const Color(0xFFAC9365),
            elevation: 0,
            title: const Text('Loading...'),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.productList.isEmpty && !controller.isLoading.value) {
        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
          appBar: AppBar(
            backgroundColor: isDarkMode ? Colors.black : const Color(0xFFAC9365),
            elevation: 0,
            title: const Text('No Products Available'),
          ),
          body: const Center(child: Text('No products found. Please try again later.')),
        );
      }

      return Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFFAC9365),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              Get.back(); // Kembali ke halaman sebelumnya
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                      hintText: 'Cari produk',
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  // Implement cart functionality here
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Bomber Jacket',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 17),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: controller.productList.length,
                itemBuilder: (context, index) {
                  final product = controller.productList[index];
                  return Card(
                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: product.image.startsWith('http')
                                      ? Image.network(
                                          product.image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const Center(child: CircularProgressIndicator());
                                            }
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Center(
                                              child: Icon(
                                                Icons.error,
                                                color: isDarkMode ? Colors.white : Colors.black,
                                              ),
                                            );
                                          },
                                        )
                                      : (product.image.isNotEmpty
                                          ? Image.file(
                                              File(product.image),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            )
                                          : Container(
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image, color: Colors.grey),
                                            )),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: const Icon(Icons.add, color: Colors.black),
                                    onPressed: () {
                                      // Navigate to product details page
                                      Get.toNamed('/description', arguments: {
                                        'title': product.title,
                                        'image': product.image,
                                        'price': product.price,
                                        'description': product.description,
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Rp ${product.price}',
                                style: const TextStyle(color: Colors.brown, fontSize: 12),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                product.description.length > 30
                                    ? '${product.description.substring(0, 30)}...'
                                    : product.description,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white54 : Colors.black54,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 3,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Penjualan'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Get.offNamed('/home-page');
                break;
              case 1:
                Get.offNamed('/category');
                break;
              case 2:
                Get.offNamed('/riwayat');
                break;
              case 3:
                // Get.offNamed('/penjualan');
                break;
              case 4:
                Get.offNamed('/account');
                break;
            }
          },
        ),
      );
    });
  }
}
