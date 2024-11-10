import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:alamo/src/features/map/data/help_center_repository.dart';

import '../domain/help_center.dart';

part 'map_service.g.dart';

class MapService {
  final HelpCenterRepository _helpCenterRepository;
  MapService(
    this._helpCenterRepository,
  );

  LatLngBounds bounds() {
    return LatLngBounds(
      southwest: const LatLng(-34.922896, -56.304919),
      northeast: const LatLng(-34.817852, -56.100616),
    );
  }

  LatLng getInitialPosition() {
    return const LatLng(-34.8971, -56.1724);
  }

  Stream<Set<Marker>> getHelpCentersMarkersStream() {
    return _helpCenterRepository.watchHelpCentersList().map((helpCenters) {
      return convertHelpCentersToMarkers(helpCenters);
    });
  }

  // Function to convert multiple HelpCenters to markers
  Set<Marker> convertHelpCentersToMarkers(List<HelpCenter> helpCenters) {
    return helpCenters.map((helpCenter) => convertHelpCenterToMarker(helpCenter)).toSet();
  }

  Marker convertHelpCenterToMarker(HelpCenter helpCenter) {
    String infoWindowContent = ' ${helpCenter.category}\n Contacto: ${helpCenter.contactNumber}';

    BitmapDescriptor icon = _getCategoryIcon(helpCenter.category);

    return Marker(
      markerId: MarkerId(helpCenter.uid),
      position: LatLng(helpCenter.coordinates['latitude']!, helpCenter.coordinates['longitude']!),
      infoWindow: InfoWindow(
        title: helpCenter.name,
        snippet: infoWindowContent,
      ),
      icon: icon,
    );
  }

  // Function to decide the marker icon based on the category
  BitmapDescriptor _getCategoryIcon(String category) {
    switch (Categories.values.firstWhere((e) => e.toString().split('.').last == category)) {
      case Categories.alimentacion:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed); // Red for Alimentacion
      case Categories.refugio:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue); // Blue for Refugio
      case Categories.salud:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen); // Green for Salud
      case Categories.vestimenta:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange); // Orange for Vestimenta
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }
}

@riverpod
MapService mapService(Ref ref) {
  final helpCenterRepository = ref.watch(helpCenterRepositoryProvider);
  return MapService(helpCenterRepository);
}
