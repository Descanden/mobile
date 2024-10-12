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
  Future<bool> requestPermissions() async {
    // Request camera permission
    var cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      Get.snackbar('Permission Denied', 'Camera access is needed to take a photo.');
      return false; // Return false if camera permission is not granted
    }

    // Request storage permission
    var storageStatus = await Permission.storage.request();
    if (!storageStatus.isGranted) {
      Get.snackbar('Permission Denied', 'Storage access is needed to save images.');
      return false; // Return false if storage permission is not granted
    }

    return true; // Both permissions are granted
  }

  // Pick image from gallery or camera
  Future<void> pickImage(String source) async {
    bool permissionsGranted = await requestPermissions(); // Ensure permissions are granted
    if (!permissionsGranted) {
      return; // Exit if permissions are not granted
    }

    try {
      if (source == 'gallery') {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );

        if (result != null && result.files.isNotEmpty) {
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
        } else {
          Get.snackbar('No Image Selected', 'Please select an image from gallery.');
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
        } else {
          Get.snackbar('No Image Taken', 'Please take a photo using the camera.');
        }
      }
    } catch (e) {
      // Handle errors while picking image
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // Helper method to update the profile image and save to GetStorage
  void updateProfileImage(String newImagePath) {
    profileImagePath.value = newImagePath; // Update profile image path
    box.write('profileImagePath', newImagePath); // Save to GetStorage
  }
}
