import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Model Pegawai
class Pegawai {
  String username;
  String password;
  String name;
  String phone;
  String address;
  String description;
  String role;
  String status;

  Pegawai({
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
    required this.address,
    required this.description,
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
      'address': address,
      'description': description,
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
      address: json['address'],
      description: json['description'],
      role: json['role'],
      status: json['status'], // Parsing status dari JSON
    );
  }
}

class PegawaiController extends GetxController {
  final pegawaiList = <Pegawai>[].obs;
  var filteredPegawai = <Pegawai>[].obs;

  PegawaiController() {
    loadPegawai();
  }

  @override
  void onInit() {
    super.onInit();
    filteredPegawai.value = pegawaiList;
  }

  // Method to add a new Pegawai
  void addPegawai(String username, String password, String name, String phone, String address, String description, String role, String status) {
    final newPegawai = Pegawai(
      username: username,
      password: password,
      name: name,
      phone: phone,
      address: address,
      description: description,
      role: role,
      status: status,
    );
    pegawaiList.add(newPegawai);
    savePegawai(); // Save to GetStorage
    searchPegawai(''); // Reset search
  }

  // Method to save pegawai to GetStorage
  void savePegawai() {
    final box = GetStorage();
    box.write('pegawai', pegawaiList.map((pegawai) => pegawai.toJson()).toList());
  }

  // Method to load pegawai from GetStorage
  void loadPegawai() {
    final box = GetStorage();
    var pegawaiFromStorage = box.read<List<dynamic>>('pegawai');
    if (pegawaiFromStorage != null) {
      pegawaiList.assignAll(
          pegawaiFromStorage.map((pegawai) => Pegawai.fromJson(Map<String, dynamic>.from(pegawai))).toList());
    }
  }

  // Method to search pegawai
  void searchPegawai(String query) {
    if (query.isEmpty) {
      filteredPegawai.value = pegawaiList;
    } else {
      filteredPegawai.value = pegawaiList
          .where((pegawai) => pegawai.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Method to filter pegawai based on status
  void filterPegawaiByStatus(String status) {
    filteredPegawai.value = pegawaiList
        .where((pegawai) => pegawai.status == status)
        .toList();
  }

  // Method to delete a pegawai
  void deletePegawai(Pegawai pegawai) {
    pegawaiList.remove(pegawai);
    savePegawai(); // Update storage after deletion
  }

  // Method to update a pegawai
  void updatePegawai(Pegawai pegawai) {
    int index = pegawaiList.indexOf(pegawai);
    if (index != -1) {
      pegawaiList[index] = pegawai; // Update pegawai details
      savePegawai(); // Save updated list
    }
  }

  // Method to change the status of a pegawai
  void updatePegawaiStatus(Pegawai pegawai, String newStatus) {
    int index = pegawaiList.indexOf(pegawai);
    if (index != -1) {
      pegawaiList[index] = Pegawai(
        username: pegawai.username,
        password: pegawai.password,
        name: pegawai.name,
        phone: pegawai.phone,
        address: pegawai.address,
        description: pegawai.description,
        role: pegawai.role,
        status: newStatus,
      );
      savePegawai();
    }
  }
}
