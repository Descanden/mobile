import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pegawai.dart';

class PegawaiDetailView extends StatelessWidget {
  final Pegawai pegawai;

  const PegawaiDetailView({super.key, required this.pegawai});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pegawai'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama: ${pegawai.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Username: ${pegawai.username}'),
            const SizedBox(height: 8),
            Text('Nomor Telepon: ${pegawai.phone}'),
            const SizedBox(height: 8),
            Text('Role: ${pegawai.role}'),
            const SizedBox(height: 8),
            Text('Status: ${pegawai.status}'),
            const SizedBox(height: 8),
            Text(
                'Password: ${pegawai.password}'), // Note: Displaying passwords is not recommended
          ],
        ),
      ),
    );
  }
}
