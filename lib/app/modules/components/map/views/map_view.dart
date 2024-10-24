import 'dart:math'; // Importing dart:math for mathematical functions
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart'; // Import polyline points
import 'package:http/http.dart' as http; // Import HTTP package
import 'dart:convert'; // Import for JSON parsing
import '../controllers/map_controller.dart' as local_map_controller;

class MapView extends GetView<local_map_controller.MapController> {
  final TextEditingController _startController = TextEditingController(); // Controller for starting location
  final TextEditingController _endController = TextEditingController(); // Controller for ending location
  final MapController _mapController = MapController();
  LatLng? _startLocation;
  LatLng? _endLocation;
  final List<Marker> _markers = [];
  List<LatLng> _polylineCoordinates = []; // List to hold the polyline coordinates

  // Method to calculate distance between two LatLng points
  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371; // Earth radius in kilometers

    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLng = _degreesToRadians(end.longitude - start.longitude);

    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in kilometers
  }

  // Method to convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Method to fetch polyline from Google Directions API
  Future<void> _getPolyline() async {
    if (_startLocation == null || _endLocation == null) return;

    const String googleApiKey = 'YOUR_GOOGLE_API_KEY'; // Ganti dengan API Key Anda

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_startLocation!.latitude},${_startLocation!.longitude}&destination=${_endLocation!.latitude},${_endLocation!.longitude}&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        PolylinePoints polylinePoints = PolylinePoints();
        List<PointLatLng> result = polylinePoints.decodePolyline(data['routes'][0]['overview_polyline']['points']);

        _polylineCoordinates.clear();
        result.forEach((point) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });

        // Panggil setState untuk memperbarui tampilan
        // Tambahkan setState jika diperlukan, tapi karena ini GetX, Anda mungkin tidak perlu
      }
    } else {
      // Tangani error jika perlu
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Gagal mendapatkan rute.')),
      );
    }
  }

  void _searchLocation() async {
    String startAddress = _startController.text.trim(); // Get start location
    String endAddress = _endController.text.trim(); // Get end location

    if (startAddress.isEmpty || endAddress.isEmpty) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Mohon masukkan nama lokasi asal dan tujuan.')),
      );
      return; // Keluar dari fungsi jika input kosong
    }

    try {
      // Get the starting location
      List<Location> startLocations = await locationFromAddress(startAddress);
      if (startLocations.isNotEmpty) {
        Location startLocation = startLocations.first;
        _startLocation = LatLng(startLocation.latitude, startLocation.longitude);
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Lokasi asal tidak ditemukan.')),
        );
        return;
      }

      // Get the ending location
      List<Location> endLocations = await locationFromAddress(endAddress);
      if (endLocations.isNotEmpty) {
        Location endLocation = endLocations.first;
        _endLocation = LatLng(endLocation.latitude, endLocation.longitude);

        // Pindahkan peta ke lokasi tujuan
        _mapController.move(_endLocation!, 15.0);

        // Tambahkan marker untuk lokasi asal dan tujuan
        _addMarker(_startLocation!, isStart: true);
        _addMarker(_endLocation!, isStart: false);

        // Hitung jarak antara lokasi asal dan tujuan
        double distance = _calculateDistance(_startLocation!, _endLocation!);
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Jarak dari $startAddress ke $endAddress: ${distance.toStringAsFixed(2)} km')),
        );

        // Panggil fungsi untuk mendapatkan polyline
        await _getPolyline();
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Lokasi tujuan tidak ditemukan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    }
  }

  void _addMarker(LatLng latLng, {required bool isStart}) {
    // Menambahkan marker untuk lokasi asal dan tujuan
    _markers.add(Marker(
      point: latLng,
      width: 80,
      height: 80,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: Get.context!,
            builder: (context) => AlertDialog(
              title: const Text('Informasi Marker'),
              content: Text('Lokasi: ${latLng.latitude}, ${latLng.longitude}'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Tutup'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        child: Icon(
          isStart ? Icons.flag : Icons.location_on, // Use different icons for start and end locations
          color: isStart ? Colors.green : Colors.red,
          size: 40,
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geoapify Map'),
        backgroundColor: const Color(0xFFAC9365),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _startController,
              decoration: InputDecoration(
                hintText: 'Masukkan lokasi asal',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchLocation,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _endController,
              decoration: InputDecoration(
                hintText: 'Masukkan lokasi tujuan',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchLocation,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onTap: (tapPosition, latLng) {
                  _addMarker(latLng, isStart: false); // Allow user to add a marker by tapping
                },
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://maps.geoapify.com/v1/tile/carto/{z}/{x}/{y}.png?apiKey=${local_map_controller.MapController.apiKey}',
                  tileProvider: NetworkTileProvider(),
                ),
                MarkerLayer(
                  markers: _markers,
                ),
                PolylineLayer( // Menambahkan PolylineLayer untuk menggambar rute
                  polylines: [
                    Polyline(
                      points: _polylineCoordinates,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
