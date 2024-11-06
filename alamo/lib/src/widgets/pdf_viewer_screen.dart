import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final File file;
  final String fileName;

  const PDFViewerScreen({required this.file, required this.fileName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          fileName,
          textScaler: const TextScaler.linear(0.8),
        ),
      ),
      body: SfPdfViewer.file(
        file,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load PDF: ${details.description}')),
          );
        },
      ),
    );
  }
}
