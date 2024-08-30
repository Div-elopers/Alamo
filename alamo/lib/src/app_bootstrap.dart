import 'package:alamo/src/app.dart';
import 'package:alamo/src/exceptions/error_logger.dart';
import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Helper class to initialize services and configure the error handlers
class AppBootstrap {
  final simpleServiceProvider = Provider<String>((ref) {
    return 'Simple Service Initialized';
  });

  /// Create the root widget that should be passed to [runApp].
  Widget createRootWidget() {
    final container = ProviderContainer();
    final errorLogger = container.read(errorLoggerProvider);
    registerErrorHandlers(errorLogger);

    return const ProviderScope(
      child: MyApp(),
    );
  }

  // Register Flutter error handlers
  void registerErrorHandlers(ErrorLogger errorLogger) {
    // * Show some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      errorLogger.logError(details.exception, details.stack);
    };
    // * Handle errors from the underlying platform/OS
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      errorLogger.logError(error, stack);
      return true;
    };
    // * Show some error UI when any widget in the app fails to build
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('Ocurrio un error'.hardcoded),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }
}
