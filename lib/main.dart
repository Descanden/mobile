import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/modules/components/user_preferences_servies.dart';
import 'app/modules/home/basket/bindings/basket_binding.dart';
import 'app/modules/home/basket/controllers/basket_controller.dart';
import 'app/modules/home/description/views/description_view.dart';
import 'app/modules/home/feed/controllers/feed_controller.dart';
import 'app/modules/home/feed/views/feed_view.dart';
import 'app/modules/home/item/controllers/item_controller.dart';
import 'app/modules/home/product/controllers/product_controller.dart';
import 'app/modules/home/product2/controllers/product2_controller.dart';
import 'app/modules/home/product3/controllers/product3_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/home/settings/controllers/settings_controller.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

/// Handler untuk pesan di background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Pesan diterima saat aplikasi terminated: ${message.messageId}");
}

/// Main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  // Inisialisasi handler untuk pesan background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

  // Initialize Controllers
  Get.put(ItemController());
  Get.put(ProductController());
  Get.put(Product2Controller());
  Get.put(Product3Controller());
  Get.put(BasketController());
  Get.put(FeedController()); // Inisialisasi FeedController

  // Load user email from SharedPreferences
  final userPreferencesService = UserPreferencesService();
  String? savedEmail = await userPreferencesService.getEmail();
  if (savedEmail != null) {
    print('Loaded email: $savedEmail');
  }

  // Mendapatkan token perangkat untuk pertama kali
  FirebaseMessaging.instance.getToken().then((token) {
    print("Device Token: $token"); // Cetak token pertama kali
  });

  // Listener untuk pembaruan token
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("Updated Device Token: $newToken");
  });

  // Listener untuk pesan yang diterima di foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Pesan diterima saat aplikasi berjalan: ${message.notification?.title}");
  });

  // Initialize Firebase In-App Messaging
  await FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: "Your App Title",
        initialRoute: Routes.LOGIN,
        getPages: [
          ...AppPages.routes,
          GetPage(
            name: '/description',
            page: () => const DescriptionView(),
            binding: BasketBinding(),
          ),
          GetPage(
            name: '/feed',
            page: () => FeedView(),
          ),
        ],
        debugShowCheckedModeBanner: false,
        theme: Get.find<SettingsController>().isDarkMode.value
            ? ThemeData.dark()
            : ThemeData.light(),
      );
    });
  }
}
