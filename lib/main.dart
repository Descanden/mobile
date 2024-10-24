import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/routes/app_pages.dart';
import 'app/modules/home/settings/controllers/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  final box = GetStorage();
  if (box.read('password') == null) {
    box.write('password', 'sasha');
  }
  if (box.read('name') == null) {
    box.write('name', 'Guest');
  }

  final settingsController = Get.put(SettingsController());
  settingsController.isDarkMode.value = box.read('darkMode') ?? false;

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
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        theme: Get.find<SettingsController>().isDarkMode.value
            ? ThemeData.dark()
            : ThemeData.light(),
      );
    });
  }
}
