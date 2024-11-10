import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapModel {
  final LatLngBounds bounds;
  final LatLng center;

  MapModel({required this.bounds, required this.center});
}
