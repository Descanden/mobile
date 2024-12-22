import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryDetailView extends StatelessWidget {
  final HistoryController controller = Get.find();

  HistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive the arguments passed from the previous page
    final history = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAD8966),
        title: const Text('Detail Riwayat'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display history details
            Text(
              'Nama: ${history.name}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text('Tanggal: ${history.date}'),
            Text('Total Belanja: Rp ${history.total}'),
            Text('Alamat: ${history.address}'),
            Text('Catatan: ${history.note}'),
            const SizedBox(height: 20),
            // Display items in the order
            const Text(
              'Detail Barang:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            for (var item in history.items)
              ListTile(
                title: Text(item['product']['title']),
                subtitle: Text('Jumlah: ${item['quantity']}'),
                trailing: Text('Rp ${item['product']['price'] * item['quantity']}'),
              ),
            const SizedBox(height: 20),
            // Button to delete the history entry
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Delete the selected history entry
                controller.deleteHistoryEntry(history);
                // Navigate back to the History page
                Get.back();
                Get.snackbar('Sukses', 'Riwayat berhasil dihapus');
              },
              child: const Text('Hapus Riwayat', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
