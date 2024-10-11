import 'package:get/get.dart';

import '../controllers/product2_controller.dart';

class Product2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Product2Controller>(
      () => Product2Controller(),
    );
  }
}
