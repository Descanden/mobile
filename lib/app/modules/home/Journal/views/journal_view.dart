import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/journal_controller.dart';

class JournalView extends GetView<JournalController> {
  const JournalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Menambahkan SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => controller.selectDate(context, true),
                    child: Obx(
                      () => SizedBox( // Mengatur ukuran untuk mencegah overflow
                        width: 150,
                        child: TextField(
                          controller: controller.startDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Tanggal Awal',
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.selectDate(context, false),
                    child: Obx(
                      () => SizedBox( // Mengatur ukuran untuk mencegah overflow
                        width: 150,
                        child: TextField(
                          controller: controller.endDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Tanggal Akhir',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              CategoryDropdown(controller: controller),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: controller.showGraph,
                child: const Text('Grafik'),
              ),
              const SizedBox(height: 16.0),
              JournalEntriesList(entries: controller.journalEntries),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final JournalController controller;

  const CategoryDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedCategory.value.isEmpty ? null : controller.selectedCategory.value,
        items: controller.categories
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
            .toList(),
        onChanged: (value) => controller.onCategorySelected(value!),
        decoration: const InputDecoration(
          labelText: 'Kategori/Produk',
        ),
        hint: const Text('Pilih Kategori'),
      ),
    );
  }
}

class JournalEntriesList extends StatelessWidget {
  final List<Map<String, String>> entries;

  const JournalEntriesList({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text('Tanggal: ${entry['date']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harga: ${entry['price']}'),
                  Text('Keterangan: ${entry['description']}'),
                  Text('Total: ${entry['total']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
