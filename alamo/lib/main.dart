import 'package:alamo/firebase_options.dart';
import 'package:alamo/src/app_bootstrap.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  usePathUrlStrategy();

  final appBootstrap = AppBootstrap();

  final root = appBootstrap.createRootWidget();

  runApp(root);
}
