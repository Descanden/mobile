import 'package:get/get.dart';

class DescriptionController extends GetxController {
  var productName = ''.obs;
  var productImage = ''.obs;
  var productDescription = ''.obs;

  void setProductDetails(String name, String image, String description) {
    productName.value = name;
    productImage.value = image;
    productDescription.value = description;
  }
}
  