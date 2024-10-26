

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
