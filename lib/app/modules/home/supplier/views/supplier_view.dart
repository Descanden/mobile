import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/supplier_controller.dart';


class SupplierView extends GetView<SupplierController> {
  const SupplierView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Expanded(
              child: Text(
                'Supplier',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black),
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
                controller.searchSupplier(value);
              },
              decoration: InputDecoration(
                hintText: 'Cari supplier',
                prefixIcon: Icon(Icons.search,
                    color: isDarkMode ? Colors.white : Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: isDarkMode ? Colors.white : Colors.brown),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          // Supplier list
          Expanded(
            child: Obx(() {
              final suppliers = controller.filteredSuppliers;
              return ListView.builder(
                itemCount: suppliers.length,
                itemBuilder: (context, index) {
                  final supplier = suppliers[index];
                  return ListTile(
                    title: Text(
                      supplier.name,
                      style: TextStyle(
                        color: isDarkMode ? Colors.brown[300] : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tileColor: isDarkMode ? Colors.grey[850] : Colors.white,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const FaIcon(FontAwesomeIcons.whatsapp,
                              color: Colors.brown),
                          onPressed: () {
                            // Handle WhatsApp action
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to EditSupplierView using named route
                            Get.toNamed('/edit-supplier', arguments: supplier);
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
                              middleText:
                                  "Apakah Anda yakin ingin menghapus supplier ini?",
                              onCancel: () => Get.back(),
                              onConfirm: () {
                                controller.deleteSupplier(supplier);
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
          // Navigate to TambahSupplierView using named route
          Get.toNamed('/tambah-supplier');
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
