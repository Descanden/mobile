import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/pegawai_controller.dart';

class PegawaiView extends GetView<PegawaiController> {
  const PegawaiView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Pegawai',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: isDarkMode ? Colors.white : Colors.black,
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                controller.searchPegawai(value);
              },
              decoration: InputDecoration(
                hintText: 'Cari pegawai',
                prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white : Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.brown),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          // Pegawai list
          Expanded(
            child: Obx(() {
              final pegawai = controller.filteredPegawai;
              return ListView.builder(
                itemCount: pegawai.length,
                itemBuilder: (context, index) {
                  final pegawaiItem = pegawai[index];
                  return ListTile(
                    title: Text(
                      pegawaiItem.name,
                      style: TextStyle(
                        color: isDarkMode ? Colors.brown[300] : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      pegawaiItem.role,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.grey,
                      ),
                    ),
                    tileColor: isDarkMode ? Colors.grey[850] : Colors.white,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.brown),
                          onPressed: () {
                            // Handle WhatsApp action
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to EditPegawaiView using named route
                            Get.toNamed('/edit-pegawai', arguments: pegawaiItem);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Show confirmation dialog before deleting
                            Get.defaultDialog(
                              title: "Konfirmasi Hapus",
                              middleText: "Apakah Anda yakin ingin menghapus pegawai ini?",
                              onCancel: () => Get.back(),
                              onConfirm: () {
                                controller.deletePegawai(pegawaiItem);
                                Get.back(); // Close the dialog
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      // Floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to TambahPegawaiView using named route
          Get.toNamed('/tambah-pegawai');
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
