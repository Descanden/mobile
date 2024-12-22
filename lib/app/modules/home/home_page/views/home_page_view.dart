import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../components/map/views/map_view.dart';
import '../../../components/webview_page.dart';
import '../controllers/home_page_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../../../../routes/app_pages.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: settingsController.isDarkMode.value
          ? const Color(0xFF121212)
          : Colors.white,
      appBar: AppBar(
        backgroundColor: settingsController.isDarkMode.value
            ? Colors.black
            : const Color(0xFFAC9365),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: settingsController.isDarkMode.value
                      ? const Color(0xFF2A2A2A)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() => TextField(
                        controller: controller.searchController,
                        style: TextStyle(
                          color: settingsController.isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search,
                              color: settingsController.isDarkMode.value
                                  ? Colors.white54
                                  : Colors.black54),
                          hintText: controller.isListening.value
                              ? 'Mendengarkan...'
                              : controller.recognizedText.value.isEmpty
                              ? 'Cari produk'
                              : controller.recognizedText.value,
                          hintStyle: TextStyle(
                              color: settingsController.isDarkMode.value
                                  ? Colors.white54
                                  : Colors.black54),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                      )),
                    ),
                    Obx(() => IconButton(
                      icon: Icon(
                        controller.isListening.value ? Icons.mic : Icons.mic_none,
                        color: controller.isListening.value
                            ? Colors.red
                            : (settingsController.isDarkMode.value
                            ? Colors.white54
                            : Colors.black54),
                      ),
                      onPressed: () {
                        if (controller.isListening.value) {
                          controller.stopListening();
                        } else {
                          controller.startListening();
                        }
                      },
                    )),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.shopping_bag_outlined,
                  color: settingsController.isDarkMode.value
                      ? Colors.white
                      : Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.instagram,
                  color: settingsController.isDarkMode.value
                      ? Colors.white
                      : Colors.black),
              onPressed: () {
                Get.to(() => WebViewPage());
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 10.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => MapView());
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    'lib/assets/Frame home.jpg',
                    height: 330,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryButton('Supplier', '/supplier',
                      settingsController.isDarkMode.value),
                  _buildCategoryButton('Operasional', '/operasional',
                      settingsController.isDarkMode.value),
                  _buildCategoryButton('Pegawai', '/pegawai',
                      settingsController.isDarkMode.value),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                  _buildIconButton('Kategori', Icons.list, '/category',
                      settingsController.isDarkMode.value),
                  _buildIconButton('Riwayat', Icons.access_time, '/history',
                      settingsController.isDarkMode.value),
                  _buildIconButton('Tambah Barang', Icons.add_circle,
                      '/item', settingsController.isDarkMode.value),
                  _buildIconButton('Feed', Icons.rss_feed, Routes.FEED,
                      settingsController.isDarkMode.value),
                  _buildIconButton('History', Icons.book, '/history',
                      settingsController.isDarkMode.value),
                  _buildIconButton('Geopify', Icons.public, '/map',
                      settingsController.isDarkMode.value), // New Button
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Penjualan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Get.toNamed(Routes.HOME_PAGE);
              break;
            case 1:
              Get.toNamed(Routes.CATEGORY);
              break;
            case 2:
              Get.toNamed(Routes.HISTORY);
              break;
            case 3:
              Get.toNamed('/penjualan');
              break;
            case 4:
              Get.toNamed(Routes.ACCOUNT);
              break;
          }
        },
      ),
    );
  }

  Widget _buildCategoryButton(String text, String route, bool isDarkMode) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Get.toNamed(route),
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF483028) : const Color(0xFF483028),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
      String label, IconData icon, String route, bool isDarkMode) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              size: 50,
              color: isDarkMode ? Colors.white : Colors.black),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}
