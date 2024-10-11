import 'package:get/get.dart';

import '../controllers/description_controller.dart';

class DescriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DescriptionController>(
      () => DescriptionController(),
    );
  }
}
