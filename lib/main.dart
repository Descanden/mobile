import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for local storage
  await GetStorage.init();

  // Create an instance of GetStorage
  final box = GetStorage();

  // Check if the password is already stored; if not, set the default password
  if (box.read('password') == null) {
    box.write('password', 'sasha');
  }

  // Initialize the default name if it doesn't exist
  if (box.read('name') == null) {
    box.write('name', 'Guest');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Your App Title",
      initialRoute: Routes.LOGIN,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
