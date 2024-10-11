import 'package:get/get.dart';

import '../controllers/tambah_supplier_controller.dart';

class TambahSupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahSupplierController>(
      () => TambahSupplierController(),
    );
  }
}
