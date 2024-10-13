import 'package:get/get.dart';

class MapController extends GetxController {
  static const String apiKey = '30d04a6bc8e84821871c8d13f748c78b';

  final String tileUrl =
      'https://maps.geoapify.com/v1/tile/carto/{z}/{x}/{y}.png?&apiKey=$apiKey';

  // Contoh koordinat peta default (Jakarta)
  final double initialLat = -6.2088;
  final double initialLon = 106.8456;

  var mapController;
}
