import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../../routes/app_pages.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi kontroler
    final RegisterController controller = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F0DA), // Warna latar belakang
      appBar: AppBar(
        backgroundColor: const Color(0xFFAC9365), // Warna AppBar
        elevation: 0,
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Create an Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF704F38), // Dark brown text
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: controller.emailController, // Properti kontroler langsung
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: Colors.grey),
                hintText: 'Email',
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => TextField(
                  controller: controller.passwordController, // Properti kontroler langsung
                  obscureText: !controller.isPasswordVisible.value, // Mengontrol visibilitas password
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: controller.isPasswordVisible.value
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        controller.togglePasswordVisibility(); // Toggle visibilitas
                      },
                    ),
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                )),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                controller.register(); // Panggil metode registrasi
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF704F38), // Dark brown background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.LOGIN); // Navigate to Login Page
              },
              child: const Text(
                'Already have an account? Login here',
                style: TextStyle(
                  color: Color(0xFF704F38), // Dark brown text
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
