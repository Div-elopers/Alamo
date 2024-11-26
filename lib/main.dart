import 'package:alamo/src/app_bootstrap.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file only in non-production environments
  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    await dotenv.load(fileName: ".env");
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  usePathUrlStrategy();

  final appBootstrap = AppBootstrap();

  final root = appBootstrap.createRootWidget();

  runApp(root);
}
