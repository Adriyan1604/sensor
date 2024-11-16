import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Model Pegawai
class Pegawai {
  String username;
  String password;
  String name;
  String phone;
  String role;
  String status;

  Pegawai({
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
    required this.role,
    required this.status,
  });

  // Method to convert Pegawai to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'phone': phone,
      'role': role,
      'status': status,
    };
  }

  // Method to convert JSON to Pegawai
  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      username: json['username'],
      password: json['password'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      status: json['status'],
    );
  }
}

class PegawaiController extends GetxController {
  final pegawaiList = <Pegawai>[].obs;
  var filteredPegawai = <Pegawai>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadPegawai();
  }

  // Method to add a new Pegawai
  void addPegawai(String username, String password, String name, String phone,
      String role, String status) async {
    final newPegawai = Pegawai(
      username: username,
      password: password,
      name: name,
      phone: phone,
      role: role,
      status: status,
    );

    try {
      await firestore.collection('pegawai').doc(username).set(newPegawai.toJson());
      pegawaiList.add(newPegawai);
      savePegawai(); // Save to local storage
      searchPegawai(''); // Reset search
    } catch (e) {
      Get.snackbar("Error", "Gagal menambahkan pegawai: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  // Method to load pegawai from Firestore and GetStorage
  void loadPegawai() async {
    final box = GetStorage();
    var pegawaiFromStorage = box.read<List<dynamic>>('pegawai');
    if (pegawaiFromStorage != null) {
      pegawaiList.assignAll(pegawaiFromStorage
          .map((pegawai) => Pegawai.fromJson(Map<String, dynamic>.from(pegawai)))
          .toList());
    }

    try {
      QuerySnapshot snapshot = await firestore.collection('pegawai').get();
      pegawaiList.assignAll(snapshot.docs.map((doc) {
        return Pegawai.fromJson(doc.data() as Map<String, dynamic>);
      }).toList());
      savePegawai(); // Save to local storage after loading from Firestore
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat pegawai: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  // Method to update a pegawai in Firestore using username as document ID
  void updatePegawai(String username, String password, String name,
      String phone, String role, String status) async {
    int index = pegawaiList.indexWhere((pegawai) => pegawai.username == username);
    if (index != -1) {
      Pegawai updatedPegawai = Pegawai(
        username: username,
        password: password,
        name: name,
        phone: phone,
        role: role,
        status: status,
      );

      try {
        await firestore.collection('pegawai').doc(username).update(updatedPegawai.toJson());
        pegawaiList[index] = updatedPegawai;
        savePegawai(); // Save updated list to local storage
      } catch (e) {
        Get.snackbar("Error", "Gagal memperbarui pegawai: $e",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    }
  }

  // Method to delete a pegawai from Firestore using username as document ID
  void deletePegawai(Pegawai pegawai) async {
    try {
      await firestore.collection('pegawai').doc(pegawai.username).delete();
      pegawaiList.remove(pegawai);
      savePegawai(); // Update storage after deletion
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus pegawai: $e",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  // Method to save pegawai list to local storage
  void savePegawai() {
    final box = GetStorage();
    box.write('pegawai', pegawaiList.map((pegawai) => pegawai.toJson()).toList());
  }

  // Method to search pegawai by name
  void searchPegawai(String query) {
    if (query.isEmpty) {
      filteredPegawai.value = pegawaiList;
    } else {
      filteredPegawai.value = pegawaiList
          .where((pegawai) =>
          pegawai.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Method to filter pegawai by status
  void filterPegawaiByStatus(String status) {
    filteredPegawai.value =
        pegawaiList.where((pegawai) => pegawai.status == status).toList();
  }
}
