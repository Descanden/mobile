import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool isPopupVisible = false.obs; // Status untuk memeriksa apakah pop-up sedang ditampilkan

  @override
  void onInit() {
    super.onInit();

    // Mendengarkan perubahan koneksi
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      if (connectivityResults.isNotEmpty) {
        _updateConnectionStatus(connectivityResults.first);
      }
    });
  }

  // Fungsi untuk mengupdate status koneksi
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      // Tampilkan pop-up jika belum ditampilkan
      if (!isPopupVisible.value) {
        isPopupVisible.value = true; // Tandai pop-up sebagai ditampilkan
        _showNoConnectionPopup();
      }
    } else {
      // Tutup pop-up jika koneksi kembali
      if (isPopupVisible.value) {
        isPopupVisible.value = false; // Tandai pop-up sebagai ditutup
        if (Navigator.canPop(Get.context!)) {
          Navigator.pop(Get.context!); // Menutup pop-up
        }
      }
      return;
    }
  }

  // Fungsi untuk menampilkan pop-up no connection
  void _showNoConnectionPopup() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const NoConnectionContent();
      },
    ).whenComplete(() {
      // Ketika pop-up ditutup secara manual
      isPopupVisible.value = false;
    });
  }
}

class NoConnectionContent extends StatelessWidget {
  const NoConnectionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ukuran sesuai konten
        children: [
          const Icon(
            Icons.wifi_off,
            size: 100,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          const Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          const Text(
            'Please check your connection and try again.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Menutup pop-up
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
