import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:get_storage/get_storage.dart';

class YourProfileController extends GetxController {
  var profileImagePath = ''.obs; // Initialize profile image path as observable
  var name = ''.obs; // Initialize name as empty
  final ImagePicker _picker = ImagePicker();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadAccountData(); // Load account data when controller is initialized
  }

  // Load the name and profile image from GetStorage
  void loadAccountData() {
    name.value = box.read('name') ?? 'Your Name'; // Load name or set default
    profileImagePath.value = box.read('profileImagePath') ?? ''; // Load profile image path
  }

  // Save the name to GetStorage
  void saveName(String newName) {
    name.value = newName; // Update the observable value
    box.write('name', newName); // Save to GetStorage
  }

  // Request permissions for camera and storage
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

  // Pick image from gallery or camera
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
            updateProfileImage(imageData); // Update profile image path
          }
        } else {
          String filePath = result.files.single.path!;
          updateProfileImage(filePath); // Update profile image path
        }
      }
    } else if (source == 'camera') {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        if (kIsWeb) {
          Uint8List bytes = await photo.readAsBytes();
          String base64Image = base64Encode(bytes);
          String imageData = 'data:image/png;base64,$base64Image';
          updateProfileImage(imageData); // Update profile image path
        } else {
          String filePath = photo.path;
          updateProfileImage(filePath); // Update profile image path
        }
      }
    }
  }

  // Helper method to update the profile image and save to GetStorage
  void updateProfileImage(String newImagePath) {
    profileImagePath.value = newImagePath; // Update profile image path
    box.write('profileImagePath', newImagePath); // Save to GetStorage
  }
}
