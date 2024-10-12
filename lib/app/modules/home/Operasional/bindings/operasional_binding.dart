import 'package:get/get.dart';

import '../controllers/operasional_controller.dart';

class OperasionalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OperasionalController>(
      () => OperasionalController(),
    );
  }
}
