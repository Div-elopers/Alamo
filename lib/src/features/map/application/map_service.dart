import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/map_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_service.g.dart';

class MapService {
  final Ref ref;

  MapService(this.ref);

  // Get the initial camera position and bounds for Municipio B
  LatLngBounds getMunicipioBBounds() {
    return ref.read(mapRepositoryProvider).municipioBBounds;
  }

  LatLng getInitialPosition() {
    return ref.read(mapRepositoryProvider).initialPosition;
  }
}

@riverpod
MapService mapService(MapServiceRef ref) {
  return MapService(ref);
}
