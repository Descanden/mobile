import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../../settings/controllers/settings_controller.dart'; // Import SettingsController

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the SettingsController to get dark mode state
    final SettingsController settingsController = Get.find<SettingsController>();

    return Obx(() {
      bool isDarkMode = settingsController.isDarkMode.value;

      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,
                          color: isDarkMode ? Colors.white54 : Colors.black54), // Icon color depending on mode
                      hintText: 'Cari produk',
                      hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white54 : Colors.black54), // Hint text color depending on mode
                      filled: true,
                      fillColor: Colors.transparent, // Transparent background for TextField
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none, // No border
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.shopping_bag_outlined,
                    color: isDarkMode ? Colors.white : Colors.black), // Shopping bag icon color depending on mode
                onPressed: () {
                  // Implement shopping bag functionality here
                },
              ),
            ],
          ),
          backgroundColor: isDarkMode ? Colors.black : const Color(0xFFAC9365),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back(); // Go back to the previous page
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.products.map((product) {
              return ProductCard(
                imagePath: product.imagePath,
                title: product.title,
                description: product.description,
                isDarkMode: isDarkMode,
              );
            }).toList(),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Fixed for more than 3 items
          currentIndex: 1, // Category page
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
                Get.offAllNamed('/home-page');
                break;
              case 1:
                // Already on Category page
                break;
              case 2:
                Get.toNamed('/riwayat');
                break;
              case 3:
                Get.toNamed('/penjualan');
                break;
              case 4:
                Get.offAllNamed('/account');
                break;
            }
          },
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      );
    });
  }
}

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isDarkMode;

  const ProductCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The image remains on the left
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imagePath,
                width: 120,  // Setting width equal to height
                height: 120, // Uniform width and height for square image
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16.0), // Space between image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[300] : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16.0), // Space between text and button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // White button background
                        foregroundColor: Colors.black, // Black text color
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, // Button width control
                          vertical: 12.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // More rectangular with slightly rounded corners
                          side: const BorderSide(color: Colors.black), // Adding a border
                        ),
                      ),
                      onPressed: () {
                        // Implement the "Check" button functionality here
                      },
                      child: const Text('Check'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
