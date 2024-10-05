import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

class YourProfileController extends GetxController {
  var profileImagePath = ''.obs;
  var name = 'Your Name'.obs; // Replace with the actual user's name if available
  final ImagePicker _picker = ImagePicker();

  // Meminta izin untuk akses kamera dan penyimpanan
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

  // Memilih gambar dari galeri atau kamera
  void pickImage(String source) async {
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
            profileImagePath.value = imageData; 
          }
        } else {
          String filePath = result.files.single.path!;
          profileImagePath.value = filePath; 
        }
      }
    } else if (source == 'camera') {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        if (kIsWeb) {
          Uint8List bytes = await photo.readAsBytes();
          String base64Image = base64Encode(bytes);
          String imageData = 'data:image/png;base64,$base64Image';
          profileImagePath.value = imageData; 
        } else {
          String filePath = photo.path;
          profileImagePath.value = filePath; 
        }
      }
    }
  }
}