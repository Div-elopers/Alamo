import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_repository.g.dart';

class MapRepository {
  // Define the bounds of Municipio B
  final LatLngBounds _bounds = LatLngBounds(
    southwest: const LatLng(-34.922896, -56.304919), // SW corner of Municipio B
    northeast: const LatLng(-34.817852, -56.100616), // NE corner of Municipio B
  );

  final _center = const LatLng(-34.8971, -56.1724);

  LatLngBounds get bounds => _bounds;

  LatLng get initialPosition => _center;
}

@Riverpod(keepAlive: true)
MapRepository mapRepository(Ref ref) {
  return MapRepository();
}
