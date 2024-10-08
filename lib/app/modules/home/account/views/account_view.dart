import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pemrograman_mobile/app/modules/home/account/views/profile_view.dart';
import '../controllers/account_controller.dart';
import '../../your_profile/controllers/your_profile_controller.dart';
import '../../../../routes/app_pages.dart';

class AccountView extends StatelessWidget {
  AccountView({super.key});
  final AccountController accountController = Get.put(AccountController());
  final YourProfileController yourProfileController = Get.put(YourProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun', style: TextStyle(color: Colors.black, fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // You can remove this if you don't want any back action
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Obx(() {
            return GestureDetector(
              onTap: () {
                _showImageSourceDialog(context);
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: yourProfileController.profileImagePath.isNotEmpty
                        ? (kIsWeb
                            ? NetworkImage(yourProfileController.profileImagePath as String) as ImageProvider
                            : FileImage(File(yourProfileController.profileImagePath as String)))
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
              yourProfileController.name.value, // Use name from YourProfileController
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          }),
          const SizedBox(height: 30),
          ProfileMenu(
            title: 'Your Profile',
            onTap: () {
              Get.toNamed(Routes.YOUR_PROFILE); // Navigate to Your Profile
            },
          ),
          ProfileMenu(
            title: 'Password Manager',
            onTap: () {
              Get.toNamed(Routes.PASSWORD_MANAGER); // Navigate to Password Manager
            },
          ),
          ProfileMenu(title: 'Settings', onTap: () {}),
          ProfileMenu(title: 'Log out', onTap: () {}),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4, // Set index for Account page
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
              Get.offAllNamed(Routes.HOME_PAGE); // Navigate to Home without back button
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
              Get.offAllNamed(Routes.ACCOUNT); // Navigate to Account without back button
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
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () {
              yourProfileController.pickImage('camera'); // Use yourProfileController
              Navigator.of(context).pop();
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              yourProfileController.pickImage('gallery'); // Use yourProfileController
              Navigator.of(context).pop();
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }
}
