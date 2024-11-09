import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_repository.g.dart';

class MapRepository {
  // Define the bounds of Municipio B
  final LatLngBounds _municipioBBounds = LatLngBounds(
    southwest: const LatLng(-34.92445, -56.20779), // SW corner of Municipio B
    northeast: const LatLng(-34.8712, -56.1374), // NE corner of Municipio B
  );

  final _center = const LatLng(-34.8971, -56.1724);

  LatLngBounds get municipioBBounds => _municipioBBounds;

  LatLng get initialPosition => _center;
}

@Riverpod(keepAlive: true)
MapRepository mapRepository(MapRepositoryRef ref) {
  return MapRepository();
}
