import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage
import 'package:pemrograman_mobile/app/modules/home/basket/controllers/basket_controller.dart';

class CheckoutView extends StatelessWidget {
  final BasketController controller = Get.find();
  final GetStorage box = GetStorage(); // Initialize GetStorage

  CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.brown),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // Filter barang yang dipilih
        final selectedItems =
            controller.items.where((item) => item['selected']).toList();

        if (selectedItems.isEmpty) {
          return const Center(child: Text('Tidak ada barang yang dipilih.'));
        }

        return Column(
          children: [
            // Alamat pengiriman
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: GestureDetector(
                onTap: () async {
                  final result =
                      await Get.toNamed('/gps'); // Navigasi ke halaman GPS
                  if (result != null) {
                    // Handle the result if there is any data returned from the GPS page
                    controller.setAddress(result['address']); // Update address if there's new data
                    controller.setName(result['name']); // Update name if there's new data
                  }
                },
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.brown),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Alamat pengiriman kamu',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            controller.selectedAddress.isEmpty
                                ? 'Tambah alamat'
                                : controller.selectedAddress.value,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Daftar barang
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final item = selectedItems[index];
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Gambar produk
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['product']['image'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Detail produk
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['product']['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Ukuran: ${item['size']}',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'harga (1X Rp${item['product']['price']})',
                                style: const TextStyle(
                                    color: Colors.brown, fontSize: 12),
                              ),
                              const SizedBox(height: 5),
                              // Menampilkan jumlah barang
                              Text(
                                'Jumlah: ${item['quantity']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Kasih catatan
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kasih catatan?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Tampilkan pop-up untuk mengisi catatan
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController noteController =
                              TextEditingController(
                                  text: box.read('orderNote') ?? ''); // Load the saved note
                          return AlertDialog(
                            title: const Text('Tambah Catatan'),
                            content: TextField(
                              controller: noteController,
                              decoration: const InputDecoration(
                                hintText: 'Tulis catatan untuk pesanan ini',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Simpan catatan ke GetStorage
                                  box.write('orderNote', noteController.text);
                                  controller.setNote(noteController.text); // Update the controller
                                  Navigator.pop(context);
                                  Get.snackbar(
                                      'Sukses', 'Catatan berhasil disimpan.');
                                },
                                child: const Text('Simpan'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.edit_note,
                        color: Colors.brown, size: 24),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Ringkasan transaksi
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cek ringkasan transaksimu, yuk',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Menampilkan nama produk dan jumlahnya
                  for (var item in selectedItems)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item['product']['title']} (x${item['quantity']})'),
                        Text('Rp${item['product']['price'] * item['quantity']}'),
                      ],
                    ),
                  const Divider(thickness: 1, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total harga',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        'Rp ${controller.selectedTotal.value}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.brown),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Tombol checkout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.checkout();
                    Get.snackbar('Sukses', 'Pesanan Anda berhasil diproses.');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Checkout Sekarang',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}