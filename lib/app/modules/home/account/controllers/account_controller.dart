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
  var account = Account().obs;
  final ImagePicker _picker = ImagePicker();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadAccountData();
  }

  void loadAccountData() {
    account.update((val) {
      val?.name = box.read('name') ?? 'Guest';
      val?.profileImagePath = box.read('profileImagePath') ?? '';
    });
  }

  void updateName(String newName) {
    account.update((val) {
      val?.name = newName;
    });
    box.write('name', newName);
  }

  void updateProfileImage(String newImagePath) {
    account.update((val) {
      val?.profileImagePath = newImagePath;
    });
    box.write('profileImagePath', newImagePath);
  }

  void logout() {
    // Don't erase the name or profile image data here
    Get.offAllNamed(Routes.LOGIN); // Redirect to login after logout
  }

  Future<void> requestPermissions() async {
    var statusCamera = await Permission.camera.status;
    if (!statusCamera.isGranted) {
      await Permission.camera.request();
    }

    var statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> pickImage(String source) async {
    await requestPermissions();

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
}
