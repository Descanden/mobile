import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Obx(() {
          bool isDarkMode = Get.find<SettingsController>().isDarkMode.value;
          return Material(
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: AppBar(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    Get.back(); // Go back to the previous page
                  },
                ),
              ),
            ),
          );
        }),
      ),
      body: Obx(() {
        bool isDarkMode = Get.find<SettingsController>().isDarkMode.value;
        return Container(
          color: isDarkMode ? const Color(0xFF121212) : Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SwitchListTile(
                value: isDarkMode,
                onChanged: (value) {
                  Get.find<SettingsController>().toggleDarkMode();
                },
                title: Text(
                  'Enable Dark Mode',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                secondary: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Tombol untuk memilih audio
              ElevatedButton(
                onPressed: _selectAudioFile,
                child: const Text('Pilih Suara Proses'),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4, // Assuming SettingsView is the last item
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Penjualan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/home-page'); // Navigate to Home
              break;
            case 1:
              Get.toNamed('/category'); // Navigate to Kategori
              break;
            case 2:
              Get.toNamed('/riwayat'); // Navigate to Riwayat
              break;
            case 3:
              Get.toNamed('/product'); // Navigate to Penjualan
              break;
            case 4:
              Get.offAllNamed('/account'); // Navigate to Account (Akun)
              break;
          }
        },
      ),
    );
  }

  // Fungsi untuk memilih file audio
  Future<void> _selectAudioFile() async {
    // Memilih file audio dari perangkat
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio, // Pilih hanya file audio
    );

    if (result != null) {
      String? filePath = result.files.single.path;

      if (filePath != null) {
        // Simpan path file audio untuk digunakan nanti
        Get.find<SettingsController>().setAudioFilePath(filePath);
        print('Audio file selected: $filePath');
      }
    } else {
      print('No audio file selected');
    }
  }
}

extension on SettingsController {
  void setAudioFilePath(String filePath) {}
}
