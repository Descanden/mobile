import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class FeedController extends GetxController {
  RxList<Feed> feeds = <Feed>[].obs;
  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initializeRecorder();
  }

  @override
  void onClose() {
    super.onClose();
    _disposeRecorder();
  }

  // Initialize the audio recorder
  Future<void> _initializeRecorder() async {
    try {
      await _audioRecorder.openAudioSession();
      _isRecorderInitialized = true;
    } catch (e) {
      print("Error initializing recorder: $e");
    }
  }

  // Dispose the audio recorder when not needed
  Future<void> _disposeRecorder() async {
    try {
      if (_isRecorderInitialized) {
        await _audioRecorder.closeAudioSession();
      }
    } catch (e) {
      print("Error disposing recorder: $e");
    }
  }

  // Add feed based on media type and message
  Future<void> addFeed(String mediaType, String message, File? mediaFile) async {
    if (mediaFile == null && mediaType != "audio") {
      // If no media file and mediaType is not audio, return
      return;
    }

    // Add feed with media if available
    feeds.add(Feed(message: message, media: mediaFile, mediaType: mediaType));
  }

  // Add a feed from audio (either record or pick from file)
  Future<void> addFeedFromAudio(String message) async {
    final useRecorder = await Get.defaultDialog<bool>(
      title: "Audio Source",
      middleText: "Do you want to record audio?",
      textCancel: "Pick from Files",
      textConfirm: "Record Audio",
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    ) ?? false;

    if (useRecorder) {
      await _startRecording();
      await Future.delayed(const Duration(seconds: 5)); // Simulate recording time
      final file = File('audio_recording.aac');
      await _stopRecording();
      feeds.add(Feed(message: message, media: file, mediaType: "audio"));
    } else {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.single.path!);
        feeds.add(Feed(message: message, media: file, mediaType: "audio"));
      }
    }
  }

  // Start audio recording
  Future<void> _startRecording() async {
    if (_isRecorderInitialized) {
      try {
        if (!_audioRecorder.isRecording) {
          await _audioRecorder.startRecorder(
            toFile: 'audio_recording.aac',
            codec: Codec.aacADTS,
          );
        }
      } catch (e) {
        print("Error starting the recorder: $e");
      }
    } else {
      print("Recorder not initialized.");
    }
  }

  // Stop audio recording
  Future<void> _stopRecording() async {
    if (_audioRecorder.isRecording) {
      try {
        await _audioRecorder.stopRecorder();
        await _audioRecorder.closeAudioSession();
      } catch (e) {
        print("Error stopping the recorder: $e");
      }
    } else {
      print("No recording in progress to stop.");
    }
  }

  // Media picking (Image or Video)
  Future<File?> pickMedia(String mediaType) async {
    final picker = ImagePicker();
    File? pickedFile;

    // Show options to choose camera or gallery
    final selectedSource = await Get.defaultDialog<int>(
      title: "Select Source",
      content: Column(
        children: [
          ElevatedButton(
            onPressed: () => Get.back(result: 0), 
            child: const Text("Take Photo/Video (Camera)"),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: 1), 
            child: const Text("Select from Gallery"),
          ),
        ],
      ),
    );

    if (selectedSource != null) {
      if (selectedSource == 0) {
        // Use camera for image/video
        if (mediaType == "image") {
          final result = await picker.pickImage(source: ImageSource.camera);
          if (result != null) pickedFile = File(result.path);
        } else if (mediaType == "video") {
          final result = await picker.pickVideo(source: ImageSource.camera);
          if (result != null) pickedFile = File(result.path);
        }
      } else if (selectedSource == 1) {
        // Use gallery for image/video
        if (mediaType == "image") {
          final result = await picker.pickImage(source: ImageSource.gallery);
          if (result != null) pickedFile = File(result.path);
        } else if (mediaType == "video") {
          final result = await picker.pickVideo(source: ImageSource.gallery);
          if (result != null) pickedFile = File(result.path);
        }
      }
    }
    return pickedFile;
  }
}

extension on FlutterSoundRecorder {
  closeAudioSession() {}
  
  openAudioSession() {}
}

class Feed {
  final String message;
  final File? media;
  final String mediaType;

  Feed({required this.message, this.media, required this.mediaType});
}
