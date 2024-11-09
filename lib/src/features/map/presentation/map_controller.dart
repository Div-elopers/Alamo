import 'dart:io';

import 'package:alamo/src/utils/notifier_mounted.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../application/map_service.dart';

part 'map_controller.g.dart';

@riverpod
class MapController extends _$MapController with NotifierMounted {
  @override
  FutureOr<void> build() {
    ref.onDispose(setUnmounted);
  }

  LatLngBounds get bounds {
    return ref.read(mapServiceProvider).getMunicipioBBounds();
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
}
