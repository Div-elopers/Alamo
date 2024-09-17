import 'dart:io';

import 'package:alamo/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'map_controller.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _googleMapController;

  @override
  Widget build(BuildContext context) {
    var mapId = "";
    if (Platform.isAndroid) {
      // Assign the Android Maps API Key
      mapId = dotenv.env['MAPS_ANDROID_ID']!;
    } else if (Platform.isIOS) {
      // Assign the iOS Maps API Key
      mapId = dotenv.env['MAPS_IOS_ID']!;
    } else {
      throw UnsupportedError('Platform not supported');
    }
    ref.listen<AsyncValue>(
      mapControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    // State of the upload operation
    final state = ref.watch(mapControllerProvider);
    final mapController = ref.read(mapControllerProvider.notifier);

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Municipio B')),
        body: GoogleMap(
          cloudMapId: mapId,
          initialCameraPosition: CameraPosition(
            target: mapController.initialPosition,
            zoom: 14,
          ),
          onMapCreated: (GoogleMapController googleMapController) {
            _googleMapController = googleMapController;
            _googleMapController!.animateCamera(
              CameraUpdate.newLatLngBounds(mapController.bounds, 10),
            );
          },
          minMaxZoomPreference: const MinMaxZoomPreference(14, 18),
          onCameraMove: (CameraPosition position) {
            if (!mapController.bounds.contains(position.target)) {
              _googleMapController!.animateCamera(
                CameraUpdate.newLatLngBounds(mapController.bounds, 10),
              );
            }
          },
        ),
      );
    }
  }
}
