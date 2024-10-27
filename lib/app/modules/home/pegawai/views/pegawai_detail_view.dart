import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pegawai_controller.dart';
import 'pegawai.dart';

class PegawaiDetailView extends StatelessWidget {
  final Pegawai pegawai;

  const PegawaiDetailView({super.key, required this.pegawai});

  @override
  Widget build(BuildContext context) {
    final PegawaiController controller = Get.find();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pegawai'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<PegawaiController>(
        builder: (controller) {
          final updatedPegawai = controller.pegawaiList.firstWhere((p) => p.username == pegawai.username);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi Pegawai',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Nama:', updatedPegawai.name, isDarkMode),
                    _buildDetailRow('Username:', updatedPegawai.username, isDarkMode),
                    _buildDetailRow('Password:', updatedPegawai.password, isDarkMode),
                    _buildDetailRow('Nomor Telepon:', updatedPegawai.phone, isDarkMode),
                    _buildDetailRow('Role:', updatedPegawai.role, isDarkMode),
                    _buildDetailRow('Status:', updatedPegawai.status, isDarkMode),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
