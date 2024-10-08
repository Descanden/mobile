import 'package:get/get.dart';

class HomePageController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.offNamed('/home'); // Home page
        break;
      case 1:
        Get.offNamed('/category'); // Kategori page
        break;
      case 2:
        Get.offNamed('/history'); // Riwayat page
        break;
      case 3:
        Get.offNamed('/sales'); // Penjualan page
        break;
      case 4:
        Get.offNamed('/account'); // Akun page (Account)
        break;
    }
  }
}
