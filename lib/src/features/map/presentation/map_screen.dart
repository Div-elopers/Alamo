import 'dart:io';
import 'package:alamo/src/features/home/home_screen.dart';
import 'package:alamo/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'map_controller.dart';
import 'package:alamo/src/features/home/bottom_navigation_bar.dart';
import 'package:alamo/src/widgets/custom_app_bar.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _googleMapController;

  @override
  Widget build(BuildContext context) {
    String? mapId;

    try {
      if (Platform.isAndroid) {
        mapId = dotenv.env['MAPS_ANDROID_ID'];
      } else if (Platform.isIOS) {
        mapId = dotenv.env['MAPS_IOS_ID'];
      } else {
        throw UnsupportedError('Plataforma no soportada');
      }

      if (mapId == null) {
        throw Exception('API key no encontrada para la plataforma actual');
      }
    } catch (e) {
      return Center(child: Text('Error: ${e.toString()}'));
    }

    ref.listen<AsyncValue>(
      mapControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(mapControllerProvider);
    final mapController = ref.read(mapControllerProvider.notifier);
    final markersStream = mapController.markersStream;

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Mapa'),
        body: StreamBuilder<Set<Marker>>(
          stream: markersStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No markers available'));
            }

            // Get the markers from the stream data
            final markers = snapshot.data!;

            return SafeArea(
              child: GoogleMap(
                markers: markers,
                cloudMapId: mapId,
                initialCameraPosition: CameraPosition(
                  target: mapController.initialPosition,
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController googleMapController) {
                  _googleMapController = googleMapController;
                },
                minMaxZoomPreference: const MinMaxZoomPreference(14, 18),
                onCameraMove: (CameraPosition position) {
                  if (!mapController.bounds.contains(position.target)) {
                    _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
                      const CameraPosition(target: LatLng(-34.904111, -56.174083)),
                    ));
                  }
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            );
          },
        ),
      );
    }
  }
}
