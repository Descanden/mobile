import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_page_controller.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F0DA), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFAC9365), // AppBar color
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    hintText: 'Cari produk',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
              onPressed: () {
                // Action for shopping bag icon
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Image (increased size and added padding)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Added vertical padding
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'lib/assets/Frame home.jpg', // Image path
                  height: 220, // Increased height slightly for a larger image
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20), // Additional spacing
            // Row of buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryButton('Supplier', '/supplier'),
                  _buildCategoryButton('Biaya Operasional', '/operational'),
                  _buildCategoryButton('Pegawai', '/employee'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Icon Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                children: [
                  _buildIconButton('Kategori', Icons.list, '/category'), // Icon updated
                  _buildIconButton('Riwayat', Icons.access_time, '/history'), // Icon updated
                  _buildIconButton('Tambah Barang', Icons.add_circle, '/add-item'), // Icon updated
                  _buildIconButton('Daftar Member', Icons.group, '/members'), // Icon updated
                  _buildIconButton('Input harga/promo', Icons.price_check, '/promo'), // Icon updated
                  _buildIconButton('Jurnal', Icons.book, '/journal'), // Icon updated
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed type for more than 3 items
        currentIndex: 0, // Set to Home by default
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
              Get.toNamed('/home'); // Navigate to Home
              break;
            case 1:
              Get.toNamed('/kategori'); // Navigate to Kategori
              break;
            case 2:
              Get.toNamed('/riwayat'); // Navigate to Riwayat
              break;
            case 3:
              Get.toNamed('/penjualan'); // Navigate to Penjualan
              break;
            case 4:
              Get.toNamed('/account'); // Navigate to Account (Akun)
              break;
          }
        },
      ),
    );
  }

  // Helper method for creating a category button
  Widget _buildCategoryButton(String text, String route) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Get.toNamed(route),
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF483028),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for creating an icon button (slightly larger icons)
  Widget _buildIconButton(String label, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Get.toNamed(route), // Navigate to specific route
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.black),  // Increased icon size slightly
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
