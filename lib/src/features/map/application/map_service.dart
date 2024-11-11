import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:alamo/src/features/map/data/help_center_repository.dart';

import '../domain/help_center.dart';
import 'package:http/http.dart' as http;

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

  Future<void> createHelpCenter(helpCenter) {
    return _helpCenterRepository.createHelpCenter(helpCenter);
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

  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    address = address.replaceAll(" ", "+");
    address = "$address,+Montevideo";
    final apiKey = dotenv.env['MAPS_WEB_API_KEY'];

    // Build the API URL with the address and API key
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Check if the API returned any results
      if (data['status'] == 'OK') {
        final lat = data['results'][0]['geometry']['location']['lat'];
        final lng = data['results'][0]['geometry']['location']['lng'];

        return {'lat': lat, 'lng': lng};
      } else {
        throw Exception('No results found for the provided address');
      }
    } else {
      throw Exception('Failed to load geocoding data');
    }
  }
}

@riverpod
MapService mapService(Ref ref) {
  final helpCenterRepository = ref.watch(helpCenterRepositoryProvider);
  return MapService(helpCenterRepository);
}
