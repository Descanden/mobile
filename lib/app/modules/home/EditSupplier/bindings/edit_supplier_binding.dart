import 'package:get/get.dart';

import '../controllers/edit_supplier_controller.dart';

class EditSupplierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditSupplierController>(
      () => EditSupplierController(),
    );
  }
}
