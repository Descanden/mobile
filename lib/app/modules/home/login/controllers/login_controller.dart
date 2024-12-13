import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Tambahkan ini
import '../../../../routes/app_pages.dart';
import '../../../components/user_preferences_servies.dart';
import '../../account/controllers/account_controller.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final box = GetStorage();
  final AccountController accountController = Get.put(AccountController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserPreferencesService _userPreferencesService = UserPreferencesService();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs; // Menambahkan variabel loading

  // Cek koneksi internet
  Future<bool> isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> login() async {
    String email = usernameController.text.trim();
    String password = passwordController.text.trim();

    // Cek koneksi internet terlebih dahulu
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      Get.snackbar(
        'No Internet Connection',
        'Please check your internet connection and try again.',
        snackPosition: SnackPosition.TOP, // Show snackbar at the top
        backgroundColor: Colors.white,
        colorText: Color(0xFF704F38), // Coklat Tua
      );
      return false;
    }

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Username and Password cannot be empty',
        snackPosition: SnackPosition.TOP, // Show snackbar at the top
        backgroundColor: Colors.white,
        colorText: Color(0xFF704F38), // Coklat Tua
      );
      return false;
    }

    try {
      isLoading.value = true; // Set loading to true
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        User? user = userCredential.user;
        print('User ID: ${user?.uid}');
        
        // Save email to SharedPreferences
        await _userPreferencesService.saveEmail(email);
        
        Get.snackbar(
          'Success',
          'Logged in successfully',
          snackPosition: SnackPosition.TOP, // Show snackbar at the top
          backgroundColor: Colors.white,
          colorText: Color(0xFF704F38), // Coklat Tua
        );

        accountController.loadAccountData();
        Get.offAllNamed(Routes.ACCOUNT);
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Invalid credentials or network error',
          snackPosition: SnackPosition.TOP, // Show snackbar at the top
          backgroundColor: Colors.white,
          colorText: Color(0xFF704F38), // Coklat Tua
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Invalid credentials or network error', // Pesan yang ditampilkan
        snackPosition: SnackPosition.TOP, // Show snackbar at the top
        backgroundColor: Colors.white,
        colorText: Color(0xFF704F38), // Coklat Tua
      );
      return false;
    } finally {
      isLoading.value = false; // Set loading to false
    }
  }

  // Forgot Password method
  Future<void> forgotPassword() async {
    String email = usernameController.text.trim();

    // Cek koneksi internet
    bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      Get.snackbar(
        'No Internet Connection',
        'Please check your internet connection and try again.',
        snackPosition: SnackPosition.TOP, // Show snackbar at the top
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Email cannot be empty',
        snackPosition: SnackPosition.TOP, // Show snackbar at the top
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Success',
        'Password reset email sent. Please check your inbox.',
        snackPosition: SnackPosition.TOP, // Show snackbar at the top
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP, // Show snackbar at the top
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
