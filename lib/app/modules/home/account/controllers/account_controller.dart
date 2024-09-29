import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/akun_model.dart';

class AccountController extends GetxController {
  var account = Account().obs;
  final ImagePicker _picker = ImagePicker();

  void pickImage(String source) async {
    if (source == 'gallery') {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        if (kIsWeb) {
          Uint8List? bytes = result.files.single.bytes; // Use bytes on web
          if (bytes != null) {
            String base64Image = base64Encode(bytes);
            String imageData = 'data:image/png;base64,$base64Image';
            account.update((acc) {
              acc?.profileImagePath = imageData; // Update with base64 image data
            });
          }
        } else {
          String filePath = result.files.single.path!;
          account.update((acc) {
            acc?.profileImagePath = filePath; // Update with the file path
          });
        }
      }
    } else if (source == 'camera') {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        if (kIsWeb) {
          Uint8List bytes = await photo.readAsBytes();
          String base64Image = base64Encode(bytes);
          String imageData = 'data:image/png;base64,$base64Image';
          account.update((acc) {
            acc?.profileImagePath = imageData; // Update with base64 image data
          });
        } else {
          String filePath = photo.path;
          account.update((acc) {
            acc?.profileImagePath = filePath; // Update with the file path
          });
        }
      }
    }
  }
}
