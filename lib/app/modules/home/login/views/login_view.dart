import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../../routes/app_pages.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F0DA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFAC9365),
        elevation: 0,
        title: const Text(
          'Masuk',
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
              'Welcome Back!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF704F38), // Dark brown text
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: controller.usernameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: Colors.grey),
                hintText: 'Username / Email',
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
                  controller: controller.passwordController,
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
              onPressed: () async {
                bool success = await controller.login();
                if (success) {
                  Get.offNamed(Routes.HOME_PAGE); // Navigate to home page
                } else {
                  Get.snackbar('Login Failed', 'Invalid credentials or network error',
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF704F38), // Dark brown background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Get.toNamed(Routes.REGISTER); // Navigate to Register Page
              },
              child: const Text(
                'Don\'t have an account? Register here',
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
