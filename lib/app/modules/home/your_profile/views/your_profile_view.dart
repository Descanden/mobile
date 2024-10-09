import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../account/controllers/account_controller.dart';
import '../controllers/your_profile_controller.dart';
import '../../settings/controllers/settings_controller.dart'; // Import SettingsController
import '../../../../routes/app_pages.dart';

class YourProfileView extends StatelessWidget {
  YourProfileView({super.key});

  final AccountController accountController = Get.find<AccountController>();
  final YourProfileController yourProfileController = Get.find<YourProfileController>();
  final SettingsController settingsController = Get.find<SettingsController>(); // Add SettingsController
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Set initial value from controller
    nameController.text = yourProfileController.name.value; // Accessing RxString value

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Obx(() { // Wrap the AppBar with Obx to make it reactive
          bool isDarkMode = settingsController.isDarkMode.value;
          return Material(
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: AppBar(
                title: Text(
                  'Your Profile',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    Get.back(); // This will take you back
                  },
                ),
              ),
            ),
          );
        }),
      ),
      body: Obx(() {
        bool isDarkMode = settingsController.isDarkMode.value; // Check dark mode status
        return Container(
          color: isDarkMode ? const Color(0xFF121212) : Colors.white, // Set background color
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _showImageSourceDialog(context);
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: yourProfileController.profileImagePath.value.isNotEmpty
                          ? (kIsWeb
                              ? NetworkImage(yourProfileController.profileImagePath.value)
                              : FileImage(File(yourProfileController.profileImagePath.value)))
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
              ),
              const SizedBox(height: 10),
              Obx(() {
                return Text(
                  yourProfileController.name.value.isNotEmpty ? yourProfileController.name.value : 'Your Name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black), // Update color
                );
              }),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Removed color to handle in Obx
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              _buildNameField(nameController, isDarkMode), // Updated to use the new method
              const Divider(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Save the name to GetStorage
                  yourProfileController.saveName(nameController.text);
                  // Show a Snackbar to confirm saving
                  Get.snackbar(
                    'Success',
                    'Your name has been saved!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  // Stay on the current page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF704F38), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
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
              Get.toNamed('/category');
              break;
            case 2:
              Get.toNamed('/riwayat');
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

  Widget _buildNameField(TextEditingController controller, bool isDarkMode) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey, width: 1),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54), // Update hint color
          ),
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Update text color
        ),
      ],
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
              yourProfileController.pickImage('camera');
              Navigator.of(context).pop();
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              yourProfileController.pickImage('gallery');
              Navigator.of(context).pop();
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }
}
