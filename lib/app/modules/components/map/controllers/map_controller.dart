import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:latlong2/latlong.dart';

class MapController extends GetxController {
  static const String apiKey = '30d04a6bc8e84821871c8d13f748c78b';

  final String tileUrl =
      'https://maps.geoapify.com/v1/tile/carto/{z}/{x}/{y}.png?&apiKey=$apiKey';
  final String placesUrl =
      'https://api.geoapify.com/v1/geocode/search?apiKey=$apiKey&text=';
  final String placeDetailsUrl =
      'https://api.geoapify.com/v1/places?apiKey=$apiKey&lat={lat}&lon={lon}';

  Future<Map<String, dynamic>> searchLocation(String query) async {
    final url = '$placesUrl$query';
    print('Request URL: $url'); // Debugging: Tampilkan URL

    try {
      final response = await http.get(Uri.parse(url));

      print('Response Status Code: ${response.statusCode}'); // Debugging
      print('Response Body: ${response.body}'); // Debugging

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'].isNotEmpty) {
          final location = data['features'][0]['geometry']['coordinates'];
          return {
            'lat': location[1],
            'lon': location[0],
          };
        } else {
          return {};
        }
      } else {
        throw Exception('Failed to load location');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging: Tampilkan error
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(double lat, double lon) async {
    final url = placeDetailsUrl.replaceAll('{lat}', lat.toString()).replaceAll('{lon}', lon.toString());
    print('Request Place Details URL: $url'); // Debugging: Tampilkan URL

    try {
      final response = await http.get(Uri.parse(url));

      print('Response Status Code: ${response.statusCode}'); // Debugging
      print('Response Body: ${response.body}'); // Debugging

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load place details');
      }
    } catch (e) {
      print('Error occurred: $e'); // Debugging: Tampilkan error
      throw Exception('Error: $e');
    }
  }

  void move(LatLng latLng, double d) {}
}
