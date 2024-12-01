import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Import untuk geocoding
import 'package:url_launcher/url_launcher.dart';
import '../controllers/gps_controller.dart';

class GpsView extends GetView<GpsController> {
  const GpsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF6F0DA),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFAC9365),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF704F38), fontSize: 16),
          bodyMedium: TextStyle(color: Color(0xFF704F38), fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF704F38),
            textStyle: const TextStyle(fontSize: 16),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      home: SearchAddressPage(),
    );
  }
}

class SearchAddressPage extends StatefulWidget {
  @override
  _SearchAddressPageState createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends State<SearchAddressPage> {
  final box = GetStorage(); // Menginisialisasi GetStorage
  final _formKey = GlobalKey<FormState>(); // Add a form key for validation
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _recipientNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _detailAddressController = TextEditingController();

  String _locationMessage = "Pilih lokasi dari Google Maps";
  String? _latitude;
  String? _longitude;

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Memuat data yang disimpan ketika halaman dimuat
    if (_latitude == null || _longitude == null) {
      _getCurrentLocation(); // Hanya dapatkan lokasi saat ini jika data belum disimpan
    }
  }

  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception('Location service not enabled');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied forever');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _locationMessage =
              "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
          _latitude = position.latitude.toString();
          _longitude = position.longitude.toString();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationMessage = 'Gagal mendapatkan lokasi: ${e.toString()}';
        });
      }
    }
  }

  // Fungsi untuk mencari lokasi berdasarkan alamat
  Future<void> _searchLocation() async {
    try {
      List<Location> locations = await locationFromAddress(_addressController.text);

      if (locations.isNotEmpty) {
        final location = locations.first;

        if (mounted) {
          setState(() {
            _latitude = location.latitude.toString();
            _longitude = location.longitude.toString();
            _locationMessage = "Lokasi ditemukan: ${_addressController.text}";
          });
        }
        // Simpan lokasi yang ditemukan
        _saveLocationData();
      } else {
        if (mounted) {
          setState(() {
            _locationMessage = "Alamat tidak ditemukan";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationMessage = "Terjadi kesalahan: ${e.toString()}";
        });
      }
    }
  }

  // Menyimpan data ke GetStorage
  void _saveLocationData() {
    box.write('latitude', _latitude);
    box.write('longitude', _longitude);
  }

  // Membuka Google Maps berdasarkan koordinat
  Future<void> _openGoogleMaps() async {
    if (_latitude != null && _longitude != null) {
      final url = Uri.parse(
          'https://www.google.com/maps?q=$_latitude,$_longitude');
      _launchURL(url);
    } else {
      if (mounted) {
        setState(() {
          _locationMessage = "Lokasi belum ditemukan";
        });
      }
    }
  }

  // Meluncurkan URL di browser
  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back(); // Kembali ke halaman sebelumnya menggunakan Get.back()
              },
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Cari Alamat'),
                Text(
                  'Dimana lokasi tujuan pengirimanmu?',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach the form key here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  hintText: 'Masukkan alamat',
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white, // White background
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _searchLocation, // Panggil pencarian lokasi
                icon: const Icon(Icons.search),
                label: const Text('Cari Lokasi'),
              ),
              const SizedBox(height: 16),
              Text(
                _locationMessage,
                style: const TextStyle(color: Color(0xFF704F38)),
              ),
              if (_latitude != null && _longitude != null) 
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Latitude: $_latitude, Longitude: $_longitude",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF704F38)),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _openGoogleMaps,
                icon: const Icon(Icons.map),
                label: const Text('Buka Google Maps'),
              ),
              const SizedBox(height: 16),
              _buildInputField('Nama Penerima', _recipientNameController, 'Nama penerima tidak boleh kosong'),
              const SizedBox(height: 16),
              _buildInputField('Nomor Hp', _phoneController, 'Nomor HP tidak boleh kosong'),
              const SizedBox(height: 16),
              _buildInputField('Label Alamat', _labelController, 'Label alamat tidak boleh kosong'),
              const SizedBox(height: 16),
              _buildInputField('Kota & Kecamatan', _cityController, 'Kota tidak boleh kosong'),
              const SizedBox(height: 16),
              _buildInputField('Alamat Lengkap', _detailAddressController, 'Alamat lengkap tidak boleh kosong'),
              const SizedBox(height: 24),
              ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      // Simpan data alamat
      _saveData();

      // Tampilkan notifikasi berhasil disimpan
      Get.snackbar(
        'Sukses',
        'Alamat berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM, // Menampilkan snackbar di bagian bawah
        backgroundColor: Colors.green, // Warna latar belakang hijau untuk keberhasilan
        colorText: Colors.white, // Warna teks putih
      );

      // Kembali ke halaman sebelumnya
      Get.back(); // Mengembalikan ke halaman sebelumnya
    }
  },
  child: const Text('Simpan Alamat'),
),

            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membangun input field yang digunakan berulang
  Widget _buildInputField(String label, TextEditingController controller, String errorMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Masukkan $label',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }

  // Fungsi untuk menyimpan data alamat yang dimasukkan
  void _saveData() {
  box.write('recipientName', _recipientNameController.text);
  box.write('phone', _phoneController.text);
  box.write('label', _labelController.text);
  box.write('city', _cityController.text);
  box.write('detailAddress', _detailAddressController.text);
}


  // Memuat data yang disimpan sebelumnya
  void _loadSavedData() {
    _recipientNameController.text = box.read('recipientName') ?? '';
    _phoneController.text = box.read('phone') ?? '';
    _labelController.text = box.read('label') ?? '';
    _cityController.text = box.read('city') ?? '';
    _detailAddressController.text = box.read('detailAddress') ?? '';
    _latitude = box.read('latitude');
    _longitude = box.read('longitude');
  }

  @override
  void dispose() {
    _addressController.dispose();
    _recipientNameController.dispose();
    _phoneController.dispose();
    _labelController.dispose();
    _cityController.dispose();
    _detailAddressController.dispose();
    super.dispose();
  }
}
