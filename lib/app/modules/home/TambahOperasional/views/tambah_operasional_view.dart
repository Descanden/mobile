import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tambah_operasional_controller.dart';

class TambahOperasionalView extends GetView<TambahOperasionalController> {
  const TambahOperasionalView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TambahOperasionalController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Biaya Operasional'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kategori Pengeluaran'),
              const SizedBox(height: 10),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedKategori.value.isEmpty
                        ? null
                        : controller.selectedKategori.value,
                    items: const [
                      DropdownMenuItem(value: 'Kategori 1', child: Text('Kategori 1')),
                      DropdownMenuItem(value: 'Kategori 2', child: Text('Kategori 2')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.pilihKategori(value);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Silahkan Pilih',
                    ),
                  )),
              const SizedBox(height: 20),
              const Text('Nilai Rp'),
              const SizedBox(height: 10),
              Obx(() => TextFormField(
                    onChanged: (value) => controller.nilaiRp.value = value,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )),
              const SizedBox(height: 20),
              const Text('Keterangan'),
              const SizedBox(height: 10),
              Obx(() => TextFormField(
                    onChanged: (value) => controller.keterangan.value = value,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )),
              const SizedBox(height: 20),
              const Text('Unggah Nota .jpg'),
              const SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: controller.pilihGambar, // Memanggil metode secara langsung
                    child: const Text('Pilih Gambar'),
                  ),
                  const SizedBox(width: 10),
                  Obx(() => Text(
                        controller.fileNota.value.isEmpty
                            ? 'Tidak ada file yang dipilih'
                            : 'File terpilih: ${controller.fileNota.value}',
                      )),
                ],
              ),
              const SizedBox(height: 5),
              const Text('Mengunggah gambar nota tidak wajib', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              const Text('Tanggal'),
              const SizedBox(height: 10),
              Obx(() => TextFormField(
                    onChanged: (value) => controller.tanggal.value = value,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'dd/mm/yyyy',
                    ),
                  )),
              const SizedBox(height: 20),
              const Text('Pembayaran'),
              const SizedBox(height: 10),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedPembayaran.value.isEmpty
                        ? null
                        : controller.selectedPembayaran.value,
                    items: const [
                      DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                      DropdownMenuItem(value: 'Transfer', child: Text('Transfer')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.pilihPembayaran(value);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Silahkan Pilih',
                    ),
                  )),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: controller.simpanOperasional,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
