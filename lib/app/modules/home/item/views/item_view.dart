import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/item_controller.dart';

class ItemView extends GetView<ItemController> {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
        centerTitle: true,
      ),
      body: GetBuilder<ItemController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Dropdown kategori
                DropdownButtonFormField<String>(
                  hint: const Text("Pilih kategori"),
                  items: controller.categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedCategory.value = value ?? ''; // Store selected category
                  },
                ),
                const SizedBox(height: 16),

                // Upload foto produk
                InkWell(
                  onTap: controller.pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: controller.image != null
                        ? Image.file(
                            File(controller.image!.path),
                            fit: BoxFit.cover,
                          )
                        : const Center(child: Text("Tambahkan Foto")),
                  ),
                ),
                const SizedBox(height: 16),

                // Input nama produk
                TextField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(labelText: 'Nama produk'),
                ),
                const SizedBox(height: 16),

                // Input harga produk
                TextField(
                  controller: controller.priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimal input
                  decoration: const InputDecoration(labelText: 'Harga'),
                ),
                const SizedBox(height: 16),

                // Input deskripsi produk
                TextField(
                  controller: controller.descriptionController, // Use descriptionController
                  decoration: const InputDecoration(labelText: 'Deskripsi'), // Change label to 'Deskripsi'
                ),
                const SizedBox(height: 16),

                // Button untuk menambah produk
                ElevatedButton(
                  onPressed: controller.saveItem, // Call the saveItem function from the controller
                  child: const Text('Tambah Barang'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
