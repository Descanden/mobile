import 'package:get/get.dart';
import '../controllers/your_profile_controller.dart';

class YourProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourProfileController>(
      () => YourProfileController(),
    );
  }
}
