import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.usernameController, // Properti controller langsung
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: Colors.grey),
                hintText: 'Username',
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
            TextField(
              controller: controller.emailController, // Properti controller langsung
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
            TextField(
              controller: controller.passwordController, // Properti controller langsung
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                hintText: 'Password',
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
