import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../account/controllers/account_controller.dart';
import '../controllers/your_profile_controller.dart'; // Import YourProfileController

class YourProfileView extends StatelessWidget {
  YourProfileView({super.key});

  final AccountController accountController = Get.find<AccountController>();
  final YourProfileController yourProfileController = Get.find<YourProfileController>();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Set initial text for nameController
    nameController.text = ''; // Kosongkan nama di awal

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Profile',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Show dialog to select new profile image
                _showImageSourceDialog(context);
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: yourProfileController.profileImagePath.isNotEmpty
                        ? NetworkImage(yourProfileController.profileImagePath as String) as ImageProvider
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
                yourProfileController.name.value.isNotEmpty ? yourProfileController.name.value : 'Your Name', // Tampilkan nama setelah di save
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            }),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(), // Garis atas
            Stack(
              alignment: Alignment.center,
              children: [
                // Oval sebagai background
                Container(
                  height: 60, // Tinggi oval
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30), // Membuat oval
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                ),
                // TextField untuk ganti nama
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    border: InputBorder.none, // Menghilangkan border default
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  onChanged: (value) {
                    // Update the name in the controller
                    yourProfileController.name.value = value; // Update name pada controller
                  },
                ),
              ],
            ),
            const Divider(), // Garis bawah
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update the name in the controller
                accountController.updateName(yourProfileController.name.value);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF704F38),
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4, // Ubah ini sesuai posisi saat ini
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
              Get.toNamed('/home');
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
              Get.toNamed('/account'); // Navigasi ke halaman akun
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
