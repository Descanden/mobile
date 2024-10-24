import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Method untuk registrasi
  Future<void> register() async {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Membuat user dan langsung menggunakan userCredential
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Jika berhasil, tampilkan snackbar sukses
      Get.snackbar(
        'Success',
        'Registration successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Optional: Tambahkan username ke profil pengguna atau database jika perlu

      // Navigasi ke halaman utama setelah registrasi
      Get.offNamed('/home'); // Ganti '/home' dengan rute yang sesuai
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
