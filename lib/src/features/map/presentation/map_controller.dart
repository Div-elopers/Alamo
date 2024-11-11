import 'dart:async';
import 'dart:io';

import 'package:alamo/src/features/map/domain/help_center.dart';
import 'package:alamo/src/utils/notifier_mounted.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../application/map_service.dart';

part 'map_controller.g.dart';

@riverpod
class MapController extends _$MapController {
  @override
  FutureOr<void> build() {}

  LatLngBounds get bounds {
    return ref.read(mapServiceProvider).bounds();
  }

  LatLng get initialPosition {
    return ref.read(mapServiceProvider).getInitialPosition();
  }

  // Stream of markers from the MapService
  Stream<Set<Marker>> get markersStream {
    return ref.read(mapServiceProvider).getHelpCentersMarkersStream();
  }

  Future<void> createHelpCenter(Map<String, dynamic> json) async {
    final address = json['address'];

    final coordinates = await getCoordinatesFromAddress(address);

    if (coordinates != null) {
      json['location'] = {
        'coordinates': {
          'latitude': coordinates['lat'],
          'longitude': coordinates['lng'],
        },
        'address': address
      };

      final helpCenter = HelpCenter.fromJson(json);

      await ref.read(mapServiceProvider).createHelpCenter(helpCenter);
    } else {
      // Handle the error if coordinates were not found
      throw Exception('Failed to get coordinates for the address');
    }
  }

  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    return ref.read(mapServiceProvider).getCoordinatesFromAddress(address);
  }
}
