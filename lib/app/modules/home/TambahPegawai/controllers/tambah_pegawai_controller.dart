import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../../pegawai/controllers/pegawai_controller.dart';

class TambahPegawaiController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();

  var selectedPegawaiRole = 'Admin'.obs; // Default role
  var selectedStatus = 'Active'.obs; // Default status

  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Initialize Firestore

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    namaController.dispose();
    nomorController.dispose();
    super.onClose();
  }

  void addPegawai(PegawaiController pegawaiController) async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();
    final String nama = namaController.text.trim();
    final String nomor = nomorController.text.trim();
    final String role = selectedPegawaiRole.value;
    final String status = selectedStatus.value;

    if (username.isNotEmpty && password.isNotEmpty && nama.isNotEmpty && nomor.isNotEmpty) {
      // Save to Firestore
      try {
        await firestore.collection('pegawai').doc(username).set({
          'username': username,
          'password': password,
          'nama': nama,
          'nomor': nomor,
          'role': role,
          'status': status,
        });

        pegawaiController.addPegawai(username, password, nama, nomor, role, status);

        // Clear inputs after adding
        clearInputs();

        Get.snackbar('Sukses', 'Pegawai berhasil ditambahkan',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } catch (e) {
        Get.snackbar('Error', 'Gagal menambahkan pegawai: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } else {
      Get.snackbar('Error', 'Semua kolom harus diisi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void clearInputs() {
    usernameController.clear();
    passwordController.clear();
    namaController.clear();
    nomorController.clear();
    selectedPegawaiRole.value = 'Admin'; // Reset to default
    selectedStatus.value = 'Active'; // Reset to default
  }
}
