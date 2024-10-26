import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pegawai/controllers/pegawai_controller.dart';
import '../../pegawai/views/pegawai.dart';
import '../controllers/edit_pegawai_controller.dart';

class EditPegawaiView extends StatelessWidget {
  final EditPegawaiController editController = Get.put(EditPegawaiController());
  final PegawaiController pegawaiController = Get.find<PegawaiController>();
  final RxBool _obscurePassword = true.obs;

  EditPegawaiView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Pegawai pegawai = Get.arguments;

    // Set Pegawai details
    editController.setPegawaiDetails(
      pegawai.username,
      pegawai.password,
      pegawai.name,
      pegawai.phone,
      pegawai.role,
      pegawai.status,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pegawai', textAlign: TextAlign.left),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kolom Username
            TextField(
              controller: TextEditingController(text: editController.username.value),
              onChanged: (value) => editController.username.value = value,
              decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Kolom Password
            Obx(() => TextField(
              controller: TextEditingController(text: editController.password.value),
              onChanged: (value) => editController.password.value = value,
              obscureText: _obscurePassword.value,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword.value ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    _obscurePassword.value = !_obscurePassword.value;
                  },
                ),
              ),
            )),
            const SizedBox(height: 10),

            // Kolom Nama Pegawai
            TextField(
              controller: TextEditingController(text: editController.namaPegawai.value),
              onChanged: (value) => editController.namaPegawai.value = value,
              decoration: InputDecoration(
                labelText: 'Nama Pegawai',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Kolom Nomor Telepon
            TextField(
              controller: TextEditingController(text: editController.nomorTelepon.value),
              onChanged: (value) => editController.nomorTelepon.value = value,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Kolom Role
            TextField(
              controller: TextEditingController(text: editController.role.value),
              onChanged: (value) => editController.role.value = value,
              decoration: InputDecoration(
                labelText: 'Role',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.brown, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Kolom Status
            TextField(
              controller: TextEditingController(text: editController.status.value),
              onChanged: (value) => editController.status.value = value,
              decoration: InputDecoration(
                labelText: 'Status',
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
                    editController.showDeleteConfirmation(pegawai);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.brown, // Warna teks tombol
                  ),
                  onPressed: () {
                    editController.updatePegawai(pegawai);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
