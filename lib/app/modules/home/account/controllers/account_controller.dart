import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:get_storage/get_storage.dart';
import '../models/akun_model.dart';
import '../../../../routes/app_pages.dart';

class AccountController extends GetxController {
  var account = Account().obs; // Account model observable
  final ImagePicker _picker = ImagePicker();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadAccountData(); // Load account data on initialization
  }

  void loadAccountData() {
    account.update((val) {
      val?.name = box.read('name') ?? 'Guest'; // Load name or set to 'Guest'
      val?.profileImagePath = box.read('profileImagePath') ?? ''; // Load profile image path
    });
  }

  void updateName(String newName) {
    account.update((val) {
      val?.name = newName; // Update name in account
    });
    box.write('name', newName); // Save new name to GetStorage
  }

  void updateProfileImage(String newImagePath) {
    account.update((val) {
      val?.profileImagePath = newImagePath; // Update profile image path in account
    });
    box.write('profileImagePath', newImagePath); // Save new image path to GetStorage
  }

  void logout() {
    // Don't erase the name or profile image data here
    Get.offAllNamed(Routes.LOGIN); // Redirect to login after logout
  }

  Future<void> requestPermissions() async {
    var statusCamera = await Permission.camera.status;
    if (!statusCamera.isGranted) {
      await Permission.camera.request(); // Request camera permission
    }

    var statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request(); // Request storage permission
    }
  }

  Future<void> pickImage(String source) async {
    await requestPermissions(); // Ensure permissions are granted

    if (source == 'gallery') {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        if (kIsWeb) {
          Uint8List? bytes = result.files.single.bytes;
          if (bytes != null) {
            String base64Image = base64Encode(bytes);
            String imageData = 'data:image/png;base64,$base64Image';
            updateProfileImage(imageData); // Update profile image in account
          }
        } else {
          String filePath = result.files.single.path!;
          updateProfileImage(filePath); // Update profile image in account
        }
      }
    } else if (source == 'camera') {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        if (kIsWeb) {
          Uint8List bytes = await photo.readAsBytes();
          String base64Image = base64Encode(bytes);
          String imageData = 'data:image/png;base64,$base64Image';
          updateProfileImage(imageData); // Update profile image in account
        } else {
          String filePath = photo.path;
          updateProfileImage(filePath); // Update profile image in account
        }
      }
    }
  }

  void pickImageFromGallery() {}

  void pickImageFromCamera() {}
}
