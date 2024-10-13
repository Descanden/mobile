import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../supplier/controllers/supplier_controller.dart';
import '../controllers/edit_supplier_controller.dart';

class EditSupplierView extends GetView<EditSupplierController> {
  const EditSupplierView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Supplier supplierData = Get.arguments;

    // Set supplier details once
    controller.setSupplierDetails(
      supplierData.name,
      supplierData.phone,
      supplierData.address,
      supplierData.description,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Supplier', textAlign: TextAlign.left),
        centerTitle: false,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Supplier Input Field
            TextField(
              controller: TextEditingController(text: controller.name.value),
              onChanged: (value) => controller.name.value = value,
              decoration: InputDecoration(
                labelText: 'Nama Supplier',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // No. Telepon Input Field
            TextField(
              controller: TextEditingController(text: controller.phone.value),
              onChanged: (value) => controller.phone.value = value,
              decoration: InputDecoration(
                labelText: 'No. Telepon',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Alamat Input Field
            TextField(
              controller: TextEditingController(text: controller.address.value),
              onChanged: (value) => controller.address.value = value,
              decoration: InputDecoration(
                labelText: 'Alamat',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Deskripsi Input Field (Text Area)
            TextFormField(
              controller: TextEditingController(text: controller.description.value),
              onChanged: (value) => controller.description.value = value,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Row for delete and save buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    controller.showDeleteConfirmation(supplierData);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.updateSupplier(supplierData);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                  ),
                  child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
