import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/password_manager_controller.dart';
import '../../../../routes/app_pages.dart';

class PasswordManagerView extends StatelessWidget {
  final PasswordManagerController controller = Get.find<PasswordManagerController>();

  PasswordManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Password Manager',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Divider(color: Colors.grey, thickness: 1),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildPasswordField(controller.oldPassword, 'Enter old password'),
                    const SizedBox(height: 20),
                    _buildPasswordField(controller.newPassword, 'Enter new password'),
                    const SizedBox(height: 20),
                    _buildPasswordField(controller.confirmPassword, 'Confirm new password'),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        try {
                          controller.updatePassword();
                          // After successful password update, navigate back to this page
                          Get.offAll(() => PasswordManagerView());
                        } on PasswordMismatchException catch (e) {
                          Get.snackbar('Error', e.message,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        } on PasswordIncorrectException catch (e) {
                          Get.snackbar('Error', e.message,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF704F38),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      child: const Text(
                        'Update Password',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Secure Your Data',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4, // Set current index to Akun
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
              Get.toNamed(Routes.ACCOUNT); // Navigate to Account
              break;
          }
        },
      ),
    );
  }

  Widget _buildPasswordField(RxString passwordController, String hintText) {
    return Obx(() {
      Color borderColor = passwordController.value.isEmpty ? Colors.red : Colors.grey;

      return TextField(
        onChanged: (value) {
          passwordController.value = value;
        },
        obscureText: true,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
      );
    });
  }
}
