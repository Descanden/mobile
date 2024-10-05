import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();  // Initialize GetStorage

  // Set initial password in GetStorage
  final box = GetStorage();
  if (box.read('password') == null) {
    box.write('password', 'sasha'); // Store initial password
  }

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
  ));
}
