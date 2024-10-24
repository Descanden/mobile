import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pemrograman_mobile/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage _box = GetStorage();
  var user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges()); // Bind user state
  }

  // Fungsi untuk login
  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User logged in: ${userCredential.user?.email}");
      
      // Simpan email ke GetStorage
      _box.write('email', email);

      Get.offAllNamed(Routes.HOME_PAGE); // Arahkan ke home setelah login berhasil
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Fungsi untuk register
  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User registered: ${userCredential.user?.email}");

      // Simpan email ke GetStorage
      _box.write('email', email);

      Get.offAllNamed(Routes.LOGIN); // Arahkan ke home setelah register berhasil
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Fungsi untuk logout
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN); // Arahkan ke halaman login setelah logout
  }

  // Fungsi untuk cek login
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Fungsi untuk mendapatkan email yang disimpan
  String? getStoredEmail() {
    return _box.read('email');
  }
}
