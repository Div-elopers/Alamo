import 'dart:io';

import 'package:alamo/src/constants/terms_path.dart';
import 'package:alamo/src/features/library/presentation/library_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:alamo/src/widgets/custom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsAndConditionsViewer extends ConsumerStatefulWidget {
  const TermsAndConditionsViewer({super.key});

  @override
  ConsumerState<TermsAndConditionsViewer> createState() => _TermsAndConditionsViewerState();
}

class _TermsAndConditionsViewerState extends ConsumerState<TermsAndConditionsViewer> {
  File? cachedFile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    const fileName = "Términos y Condiciones.pdf"; // Replace with your actual file name

    try {
      // Check if file exists in the cache directory
      final directory = await getTemporaryDirectory();
      final cachedFilePath = '${directory.path}/$fileName';
      final file = File(cachedFilePath);

      if (file.existsSync()) {
        // Use cached file
        setState(() {
          cachedFile = file;
          isLoading = false;
        });
      } else {
        // Download and cache the file
        final downloadedFile = await ref.read(libraryScreenControllerProvider.notifier).downloadFile(termsPath, fileName);

        await downloadedFile.copy(cachedFilePath); // Cache the file

        setState(() {
          cachedFile = File(cachedFilePath);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading Terms and Conditions: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cachedFile != null
              ? SfPdfViewer.file(
                  cachedFile!,
                  onDocumentLoadFailed: (details) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to load PDF: ${details.description}')),
                    );
                  },
                )
              : const Center(child: Text('No se pudo cargar el archivo.')),
    );
  }
}
