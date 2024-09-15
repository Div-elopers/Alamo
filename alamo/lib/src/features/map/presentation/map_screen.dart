// map_screen.dart

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
  final map_ID = dotenv.env['MAPS_IOS_ID'];
  @override
  Widget build(BuildContext context) {
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
          cloudMapId: map_ID,
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
