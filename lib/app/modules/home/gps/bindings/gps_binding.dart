import 'package:get/get.dart';

import '../controllers/gps_controller.dart';

class GpsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GpsController>(
      () => GpsController(),
    );
  }
}
