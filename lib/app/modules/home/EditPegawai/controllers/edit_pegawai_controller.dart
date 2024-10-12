import 'package:get/get.dart';

class EditPegawaiController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var namaPegawai = ''.obs;
  var nomorTelepon = ''.obs;
  var role = ''.obs;
  var status = ''.obs;

  // Menyiapkan detail pegawai yang ingin diedit
  void setPegawaiDetails(String username, String password, String namaPegawai, String nomorTelepon, String role, String status) {
    this.username.value = username;
    this.password.value = password;
    this.namaPegawai.value = namaPegawai;
    this.nomorTelepon.value = nomorTelepon;
    this.role.value = role;
    this.status.value = status;
  }

  // Logika untuk mengupdate pegawai
  void updatePegawai(String username, String password, String namaPegawai, String nomorTelepon, String role, String status) {
    // Tambahkan logika penyimpanan atau pembaruan di sini
    print('Pegawai diperbarui: $username, $password, $namaPegawai, $nomorTelepon, $role, $status');
  }
}
