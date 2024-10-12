import 'package:get/get.dart';

import '../controllers/tambah_operasional_controller.dart';

class TambahOperasionalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahOperasionalController>(
      () => TambahOperasionalController(),
    );
  }
}
