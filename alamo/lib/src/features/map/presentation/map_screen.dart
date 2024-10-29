import 'dart:io';
import 'package:alamo/src/features/home/home_screen.dart';
import 'package:alamo/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'map_controller.dart';
import 'package:alamo/src/features/home/home_app_bar/bottom_navigation_bar.dart';
import 'package:alamo/src/widgets/custom_app_bar.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
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
    final currentIndex =
        ref.watch(currentIndexProvider); // Lee el índice actual

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Mapa'), // Usar CustomAppBar aquí
        body: Stack(
          children: [
            GoogleMap(
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  ref.read(currentIndexProvider.notifier).state = index;
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
