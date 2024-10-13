import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/map_controller.dart' as local_map_controller;

class MapView extends GetView<local_map_controller.MapController> {
  final TextEditingController _controller = TextEditingController();
  final MapController _mapController = MapController();
  LatLng? _location;
  final List<Marker> _markers = []; // Store markers directly

  void _searchLocation() async {
    String address = _controller.text;

    try {
      // Mencari lokasi dari alamat yang diberikan
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        // Ambil koordinat dari lokasi pertama
        Location location = locations.first;
        _location = LatLng(location.latitude, location.longitude);

        // Pindahkan peta ke lokasi yang dicari
        _mapController.move(_location!, 15.0);
      } else {
        // Tampilkan pesan jika tidak ada lokasi ditemukan
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text('Lokasi tidak ditemukan.'),
        ));
      }
    } catch (e) {
      // Tangani kesalahan
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan: $e'),
      ));
    }
  }

  void _addMarker(LatLng latLng) {
    _markers.add(Marker(
      point: latLng,
      width: 80,
      height: 80,
      // Directly use the widget instead of using 'builder' or 'widget'
      // Use a child widget directly
      child: GestureDetector(
        onTap: () {
          // Show info dialog when marker tapped
          showDialog(
            context: Get.context!,
            builder: (context) => AlertDialog(
              title: const Text('Marker Info'),
              content: Text('Location: ${latLng.latitude}, ${latLng.longitude}'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
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
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Masukkan nama lokasi',
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
                  // Menambahkan marker ketika peta di-tap
                  _addMarker(latLng);
                },
                maxZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://maps.geoapify.com/v1/tile/carto/{z}/{x}/{y}.png?apiKey=${local_map_controller.MapController.apiKey}',
                  tileProvider: NetworkTileProvider(),
                ),
                MarkerLayer(
                  markers: _markers, // Menampilkan semua marker
                ),
              ],
            ),
          ),
          if (_location != null)
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Text(
                'Lokasi ditemukan: ${_location!.latitude}, ${_location!.longitude}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}