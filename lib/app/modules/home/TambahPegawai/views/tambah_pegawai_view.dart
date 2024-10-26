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
                  border: const OutlineInputBorder(),
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
                  border: const OutlineInputBorder(),
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
                  border: const OutlineInputBorder(),
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
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              // Dropdown role pegawai
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedPegawaiRole.value,
                    decoration: InputDecoration(
                      labelText: 'Role Pegawai',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                    items: ['Admin', 'Staff', 'Manager']
                        .map((role) => DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedPegawaiRole.value = value;
                      }
                    },
                  )),
              const SizedBox(height: 10),
              // Dropdown status pegawai
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedStatus.value,
                    decoration: InputDecoration(
                      labelText: 'Status Pegawai',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                    items: ['Active', 'Inactive']
                        .map((status) => DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedStatus.value = value;
                      }
                    },
                  )),
              const SizedBox(height: 20),
              // Tombol untuk menambahkan pegawai
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown, // Mengubah latar belakang tombol
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Menambahkan padding
                  ),
                  onPressed: () {
                    controller.addPegawai(); // Call without parameters
                  },
                  child: const Text(
                    'Tambah Pegawai',
                    style: TextStyle(color: Colors.white), // Mengubah warna teks menjadi putih
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
