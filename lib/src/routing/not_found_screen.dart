import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:alamo/src/widgets/empty_placeholder_widget.dart';
import 'package:flutter/material.dart';

/// Simple not found screen used for 404 errors (page not found on web)
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: EmptyPlaceholderWidget(
        message: '404 - Pagina no encontrada!'.hardcoded,
      ),
    );
  }
}
