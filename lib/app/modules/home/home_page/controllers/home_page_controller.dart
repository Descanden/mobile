import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class HomePageController extends GetxController {
  var currentIndex = 0.obs;
  final searchController = TextEditingController();
  final speechToText = stt.SpeechToText();
  var isListening = false.obs;
  var recognizedText = "".obs;
  var speechEnabled = false.obs;
  var availableLocales = <stt.LocaleName>[].obs;

  @override
  void onInit() {
    super.onInit();
    _checkMicrophonePermission();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> _checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      await _initSpeech();
    } else {
      Get.snackbar(
        'Izin Ditolak',
        'Aplikasi membutuhkan izin mikrofon untuk fitur ini.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _initSpeech() async {
    try {
      // Inisialisasi Speech-to-Text
      speechEnabled.value = await speechToText.initialize(
        onError: (error) {
          print("Error SpeechToText: $error");
          _handleSpeechError(error.errorMsg);
        },
        onStatus: (status) {
          print("Status SpeechToText: $status");
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
        debugLogging: true,
      );

      if (speechEnabled.value) {
        // Mendapatkan daftar locale
        availableLocales.value = await speechToText.locales();

        // Memeriksa apakah bahasa Indonesia tersedia
        final indonesianLocale = availableLocales.firstWhere(
              (locale) => locale.localeId.startsWith('id_'),
          orElse: () => availableLocales.first,
        );

        print("Selected locale: ${indonesianLocale.localeId}");
      } else {
        Get.snackbar(
          'Perhatian',
          'Fitur pengenalan suara tidak tersedia pada perangkat ini.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Error in _initSpeech: $e");
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat menginisialisasi pengenalan suara.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> startListening() async {
    if (!speechEnabled.value) {
      await _initSpeech();
    }

    if (speechEnabled.value) {
      try {
        // Memilih locale Indonesia atau fallback
        final indonesianLocale = availableLocales.firstWhere(
              (locale) => locale.localeId.startsWith('id_'),
          orElse: () => availableLocales.first,
        );

        isListening.value = true;
        recognizedText.value = '';

        await speechToText.listen(
          onResult: (result) {
            if (result.recognizedWords.isNotEmpty) {
              recognizedText.value = result.recognizedWords;
              searchController.text = recognizedText.value;
              searchController.selection = TextSelection.fromPosition(
                TextPosition(offset: searchController.text.length),
              );
            }
          },
          localeId: indonesianLocale.localeId,
          listenMode: stt.ListenMode.dictation, // Mode dictation untuk hasil maksimal
          cancelOnError: false,
          partialResults: true,
          listenFor: const Duration(seconds: 30), // Timeout 30 detik
          pauseFor: const Duration(seconds: 3), // Jeda 3 detik
        );
      } catch (e) {
        print("Error in startListening: $e");
        isListening.value = false;
        Get.snackbar(
          'Error',
          'Terjadi kesalahan saat memulai pengenalan suara.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> stopListening() async {
    try {
      await speechToText.stop();
      isListening.value = false;
    } catch (e) {
      print("Error in stopListening: $e");
    }
  }

  void _handleSpeechError(String errorMsg) {
    isListening.value = false;

    String userMessage = 'Terjadi kesalahan saat pengenalan suara.';

    if (errorMsg.contains('error_speech_timeout')) {
      userMessage = 'Waktu pengenalan suara habis. Pastikan Anda berbicara dengan jelas.';
    } else if (errorMsg.contains('error_no_match')) {
      userMessage = 'Tidak ada suara yang cocok terdeteksi. Silakan coba lagi.';
    } else if (errorMsg.contains('error_busy')) {
      userMessage = 'Layanan pengenalan suara sedang sibuk. Silakan coba lagi.';
    }

    Get.snackbar(
      'Error',
      userMessage,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void changePage(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.offNamed('/home');
        break;
      case 1:
        Get.offNamed('/category');
        break;
      case 2:
        Get.offNamed('/history');
        break;
      case 3:
        Get.offNamed('/sales');
        break;
      case 4:
        Get.offNamed('/account');
        break;
    }
  }
}