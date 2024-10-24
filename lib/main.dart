import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/modules/components/user_preferences_servies.dart';
import 'app/modules/home/item/controllers/item_controller.dart';
import 'app/modules/home/product/controllers/product_controller.dart';
import 'app/modules/home/product2/controllers/product2_controller.dart';
import 'app/modules/home/product3/controllers/product3_controller.dart'; // Import Product3Controller
import 'app/routes/app_pages.dart';
import 'app/modules/home/settings/controllers/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  final box = GetStorage();
  // Cek dan set nilai default jika belum ada
  if (box.read('password') == null) {
    box.write('password', 'sasha');
  }
  if (box.read('name') == null) {
    box.write('name', 'Guest');
  }

  // Inisialisasi SettingsController dan set nilai Dark Mode
  final settingsController = Get.put(SettingsController());
  settingsController.isDarkMode.value = box.read('darkMode') ?? false;

  // Initialize ItemController and ProductController
  Get.put(ItemController());
  Get.put(ProductController());

  // Initialize Product2Controller
  Get.put(Product2Controller()); 

  // Initialize Product3Controller
  Get.put(Product3Controller());

  // Load user email from SharedPreferences
  final userPreferencesService = UserPreferencesService();
  String? savedEmail = await userPreferencesService.getEmail();
  if (savedEmail != null) {
    // You can use the saved email as needed
    print('Loaded email: $savedEmail');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: "Your App Title",
        initialRoute: Routes.LOGIN, // Atur rute awal
        getPages: AppPages.routes, // Rute aplikasi
        debugShowCheckedModeBanner: false, // Hilangkan banner debug
        theme: Get.find<SettingsController>().isDarkMode.value
            ? ThemeData.dark() // Tema gelap
            : ThemeData.light(), // Tema terang
      );
    });
  }
}
