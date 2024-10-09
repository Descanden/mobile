import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pemrograman_mobile/app/modules/home/account/controllers/account_controller.dart';
import 'package:pemrograman_mobile/app/modules/home/your_profile/controllers/your_profile_controller.dart';
import 'package:pemrograman_mobile/app/modules/home/settings/controllers/settings_controller.dart'; // Import SettingsController
import '../../../../routes/app_pages.dart';

class AccountView extends StatelessWidget {
  AccountView({super.key});

  final AccountController accountController = Get.put(AccountController());
  final YourProfileController yourProfileController = Get.put(YourProfileController());
  final SettingsController settingsController = Get.put(SettingsController()); // Initialize SettingsController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun', style: TextStyle(fontSize: 20)), // Teks tanpa warna
        centerTitle: true,
        backgroundColor: settingsController.isDarkMode.value ? Colors.black : Colors.white, // Ubah warna latar belakang
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Tanpa warna khusus
          onPressed: () => Get.back(),
          color: settingsController.isDarkMode.value ? Colors.white : Colors.black, // Ubah warna ikon
        ),
      ),
      body: Obx(() {
        bool isDarkMode = settingsController.isDarkMode.value; // Get dark mode status
        return Container(
          color: isDarkMode ? const Color(0xFF121212) : Colors.white, // Warna latar belakang
          child: Column(
            children: [
              const SizedBox(height: 20),
              Obx(() {
                String imagePath = yourProfileController.profileImagePath.value; // Accessing the value
                return GestureDetector(
                  onTap: () => _showImageSourceDialog(context),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: imagePath.isNotEmpty && File(imagePath).existsSync()
                            ? (kIsWeb
                                ? NetworkImage(imagePath)
                                : FileImage(File(imagePath)))
                            : const AssetImage('lib/assets/Formal_Rofiq.jpg'),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              Obx(() {
                return Text(
                  yourProfileController.name.value, // Accessing the value
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black, // Ubah warna teks
                  ),
                );
              }),
              const SizedBox(height: 30),

              // Profile Menu with Divider
              ProfileMenu(
                title: 'Your Profile',
                onTap: () => Get.toNamed(Routes.YOUR_PROFILE),
              ),
              Divider(color: isDarkMode ? Colors.grey : Colors.brown), // Warna pemisah

              ProfileMenu(
                title: 'Password Manager',
                onTap: () => Get.toNamed(Routes.PASSWORD_MANAGER),
              ),
              Divider(color: isDarkMode ? Colors.grey : Colors.brown), // Warna pemisah

              ProfileMenu(
                title: 'Settings',
                onTap: () => Get.toNamed(Routes.SETTINGS), // Navigate to Settings page
              ),
              Divider(color: isDarkMode ? Colors.grey : Colors.brown), // Warna pemisah

              ProfileMenu(
                title: 'Log out',
                onTap: () => _showLogoutConfirmation(context),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4,
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
              Get.offAllNamed(Routes.HOME_PAGE);
              break;
            case 1:
              Get.toNamed('/kategori');
              break;
            case 2:
              Get.toNamed('/riwayat');
              break;
            case 3:
              Get.toNamed('/penjualan');
              break;
            case 4:
              Get.offAllNamed(Routes.ACCOUNT);
              break;
          }
        },
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source', style: TextStyle(color: Colors.black)), // Teks hitam
        actions: [
          TextButton(
            onPressed: () {
              yourProfileController.pickImage('camera');
              Navigator.of(context).pop();
            },
            child: const Text('Camera', style: TextStyle(color: Colors.black)), // Teks hitam
          ),
          TextButton(
            onPressed: () {
              yourProfileController.pickImage('gallery');
              Navigator.of(context).pop();
            },
            child: const Text('Gallery', style: TextStyle(color: Colors.black)), // Teks hitam
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        bool isDarkMode = settingsController.isDarkMode.value; // Get dark mode status
        return Container(
          padding: const EdgeInsets.all(20),
          height: 200,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white, // Warna latar belakang
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black, // Ubah warna teks
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 60,
                    height: 2,
                    color: isDarkMode ? Colors.white : Colors.black, // Ubah warna garis
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Are you sure want to log out?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: isDarkMode ? Colors.white : Colors.black, // Ubah warna teks
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      accountController.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                    ),
                    child: const Text('Log out', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileMenu({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<SettingsController>().isDarkMode.value; // Get dark mode status
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Ubah warna teks
      ),
      onTap: onTap,
    );
  }
}
