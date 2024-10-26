import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../views/pegawai.dart';

class PegawaiController extends GetxController {
  final pegawaiList = <Pegawai>[].obs;
  var filteredPegawai = <Pegawai>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Initialize Firestore

  PegawaiController() {
    loadPegawai();
  }

  @override
  void onInit() {
    super.onInit();
    filteredPegawai.value = pegawaiList;
  }

  // Method to add a new Pegawai
  Future<void> addPegawai(String username, String password, String name, String phone, String role, String status) async {
    final newPegawai = Pegawai(
      username: username,
      password: password,
      name: name,
      phone: phone,
      role: role,
      status: status,
    );

    await firestore.collection('pegawai').add(newPegawai.toJson()); // Save to Firestore
    pegawaiList.add(newPegawai);
    searchPegawai(''); // Reset search
  }

  // Method to load pegawai from Firestore
  Future<void> loadPegawai() async {
    final querySnapshot = await firestore.collection('pegawai').get();
    pegawaiList.assignAll(
      querySnapshot.docs.map((doc) => Pegawai.fromJson(doc.data() as Map<String, dynamic>)).toList(),
    );
  }

  // Method to search pegawai
  void searchPegawai(String query) {
    if (query.isEmpty) {
      filteredPegawai.value = pegawaiList;
    } else {
      filteredPegawai.value = pegawaiList.where((pegawai) =>
          pegawai.name.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  // Method to delete a pegawai
  Future<void> deletePegawai(Pegawai pegawai) async {
    final querySnapshot = await firestore.collection('pegawai')
        .where('username', isEqualTo: pegawai.username).get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        await firestore.collection('pegawai').doc(doc.id).delete();
      }
      pegawaiList.remove(pegawai);
    }
  }

  // Method to update a pegawai
  Future<void> updatePegawai(String currentUsername, String newUsername, String password, String name,
      String phone, String role, String status) async {
    // Check if the new username is already taken
    final existingUsers = await firestore.collection('pegawai')
        .where('username', isEqualTo: newUsername).get();

    if (existingUsers.docs.isNotEmpty && newUsername != currentUsername) {
      Get.snackbar('Error', 'Username sudah terdaftar.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Find the document by current username
    final querySnapshot = await firestore.collection('pegawai')
        .where('username', isEqualTo: currentUsername).get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        // Update the document
        await firestore.collection('pegawai').doc(doc.id).update({
          'username': newUsername,
          'password': password,
          'name': name,
          'phone': phone,
          'role': role,
          'status': status,
        });
      }
      await loadPegawai(); // Refresh the list after updating
    } else {
      Get.snackbar('Error', 'Pegawai tidak ditemukan.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
