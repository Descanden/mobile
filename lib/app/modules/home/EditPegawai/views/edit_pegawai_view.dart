import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pegawai/controllers/pegawai_controller.dart';
import '../controllers/edit_pegawai_controller.dart';

class EditPegawaiView extends StatelessWidget {
  final EditPegawaiController editController = Get.put(EditPegawaiController());
  final PegawaiController pegawaiController = Get.find<PegawaiController>();
  final RxBool _obscurePassword = true.obs; // Menyimpan status password

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
        backgroundColor: Colors.transparent, // Mengatur warna latar belakang menjadi transparan
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian ini dihapus untuk menghilangkan garis di bawah header
            // const Divider(thickness: 2.0, color: Colors.grey),

            // Username Input Field
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

            // Password Input Field
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
                    _obscurePassword.value = !_obscurePassword.value; // Toggle visibility
                  },
                ),
              ),
            )),
            const SizedBox(height: 10),

            // Nama Pegawai Input Field
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

            // Nomor Telepon Input Field
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

            // Role Input Field
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

            // Status Input Field
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
                    // Tambahkan fungsi konfirmasi hapus jika diperlukan
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    editController.updatePegawai(
                      editController.username.value,
                      editController.password.value,
                      editController.namaPegawai.value,
                      editController.nomorTelepon.value,
                      editController.role.value,
                      editController.status.value,
                    );
                    Get.back(); // Kembali setelah menyimpan
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
