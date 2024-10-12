import 'package:get/get.dart';

import '../controllers/pegawai_controller.dart';

class PegawaiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PegawaiController>(
      () => PegawaiController(),
    );
  }
}
