import 'dart:async';
import 'dart:io';

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

  String getApiKey() {
    if (kIsWeb) {
      return dotenv.env['MAPS_WEB_API_KEY'] ?? '';
    } else if (Platform.isAndroid) {
      return dotenv.env['MAPS_ANDROID_API_KEY'] ?? '';
    } else if (Platform.isIOS) {
      return dotenv.env['MAPS_IOS_API_KEY'] ?? '';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Stream of markers from the MapService
  Stream<Set<Marker>> get markersStream {
    return ref.read(mapServiceProvider).getHelpCentersMarkersStream();
  }
}
