import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_item_controller.dart';

class AddItemView extends GetView<AddItemController> {
  const AddItemView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine if the theme is dark mode
    final bool isDarkMode = Get.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFFA99577), // Dark mode uses black
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: isDarkMode ? Colors.white : Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButtonFormField<String>(
                value: controller.selectedCategory.value.isEmpty
                    ? null
                    : controller.selectedCategory.value, // Set to null if no selection
                hint: Text(
                  'Pilih kategori',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (String? newValue) {
                  controller.selectedCategory.value = newValue ?? '';
                },
                items: <String>['Kategori 1', 'Kategori 2', 'Kategori 3']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                  );
                }).toList(),
              ),
            )),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                controller.pickImage(); // Call function to pick image
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: isDarkMode ? Colors.white : Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Obx(() => controller.productImagePath.value.isEmpty
                    ? Text(
                        'Tambahkan Foto',
                        style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white : Colors.black),
                      )
                    : Image.network(controller.productImagePath.value, fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nama produk',
                labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.grey),
                ),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              onChanged: (value) {
                controller.productName.value = value;
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Harga',
                labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.grey),
                ),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.productPrice.value = double.tryParse(value) ?? 0.0;
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Size',
                labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.grey),
                ),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              onChanged: (value) {
                controller.productSize.value = value;
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jumlah:',
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, color: isDarkMode ? Colors.white : Colors.black),
                      onPressed: () {
                        if (controller.quantity.value > 1) {
                          controller.quantity.value--;
                        }
                      },
                    ),
                    Obx(() => Text(
                          controller.quantity.value.toString(),
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        )),
                    IconButton(
                      icon: Icon(Icons.add, color: isDarkMode ? Colors.white : Colors.black),
                      onPressed: () {
                        controller.quantity.value++;
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.saveItem(); // Save the item
        },
        backgroundColor: isDarkMode ? Colors.black : Colors.black, // Black for both modes
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Positioned in the bottom-right
    );
  }
}
