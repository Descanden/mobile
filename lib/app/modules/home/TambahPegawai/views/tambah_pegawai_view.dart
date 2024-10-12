import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pegawai/controllers/pegawai_controller.dart';
import '../controllers/tambah_pegawai_controller.dart';

class TambahPegawaiView extends GetView<TambahPegawaiController> {
  const TambahPegawaiView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil controller pegawai
    final PegawaiController pegawaiController = Get.find<PegawaiController>();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pegawai'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Input field untuk username
              TextField(
                controller: controller.usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              // Input field untuk password
              TextField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
                obscureText: true, // Menyembunyikan password
              ),
              const SizedBox(height: 10),
              // Input field untuk nama pegawai
              TextField(
                controller: controller.namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Pegawai',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              // Input field untuk nomor telepon
              TextField(
                controller: controller.nomorController,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              // Input field untuk alamat
              TextField(
                controller: controller.addressController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              // Input field untuk deskripsi
              TextField(
                controller: controller.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              // Dropdown role pegawai
              Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedPegawaiRole.value,
                onChanged: (newValue) {
                  controller.selectedPegawaiRole.value = newValue!;
                },
                items: <String>['Admin', 'Kasir', 'Karyawan', 'Gudang'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Role Pegawai',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
              )),
              const SizedBox(height: 10),
              // Dropdown status pegawai
              Obx(() => DropdownButtonFormField<String>(
                value: controller.selectedStatus.value,
                onChanged: (newValue) {
                  controller.selectedStatus.value = newValue!;
                },
                items: <String>['Active', 'Inactive'].map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Status Pegawai',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
              )),
              const SizedBox(height: 20),
              // Tombol simpan pegawai
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi untuk menambah pegawai
                    controller.addPegawai(pegawaiController);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
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
