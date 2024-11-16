// detail_pegawai_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pegawai_controller.dart'; // Import controller sesuai dengan path
import '../controllers/pegawai_controller.dart';

class DetailPegawaiView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pegawai = Get.arguments; // Mengambil data pegawai dari arguments
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pegawai'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama: ${pegawai.name}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Username: ${pegawai.username}",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Role: ${pegawai.role}",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Status: ${pegawai.status}",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Nomor Telepon: ${pegawai.phone}",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Password: ${pegawai.password}",
              style: TextStyle(fontSize: 16, color: Colors.grey), // Bisa di-hidden atau dienkripsi
            ),
          ],
        ),
      ),
    );
  }
}
