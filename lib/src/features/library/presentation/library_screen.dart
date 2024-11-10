import 'dart:developer';
import 'dart:io';

import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/library/domain/app_file.dart';
import 'package:alamo/src/features/library/presentation/library_screen_controller.dart';
import 'package:alamo/src/widgets/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(libraryScreenControllerProvider);
    final controller = ref.read(libraryScreenControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              // Implement file upload (e.g., show file picker and call controller.uploadFile)
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: controller.updateSearchQuery,
                    decoration: const InputDecoration(
                      labelText: 'Buscar',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  hint: const Text('Filtro'),
                  value: state.selectedFilter,
                  items: ['PDF', 'VIDEO', 'DOC'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: controller.setFilter,
                ),
              ],
            ),
            gapH16,
            Expanded(
              child: ListView.builder(
                itemCount: state.filteredFiles.length,
                itemBuilder: (context, index) {
                  final appFile = state.filteredFiles[index];

                  return LibraryFileItem(
                    appFile: appFile,
                    onFileDownloaded: (file) async {
                      await controller.downloadFile(appFile.fileURL, appFile.name);
                    },
                    onView: () {
                      controller.openFile(appFile);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LibraryFileItem extends StatefulWidget {
  final AppFile appFile;
  final Future<void> Function(File file) onFileDownloaded;
  final VoidCallback onView;

  const LibraryFileItem({
    super.key,
    required this.appFile,
    required this.onFileDownloaded,
    required this.onView,
  });

  @override
  createState() => _LibraryFileItemState();
}

class _LibraryFileItemState extends State<LibraryFileItem> {
  File? _cachedFile;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _loadCachedFile();
  }

  Future<void> _loadCachedFile() async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${widget.appFile.name}';
    final file = File(filePath);

    if (await file.exists()) {
      setState(() {
        _cachedFile = file;
      });
    }
  }

  Future<void> _downloadFile() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${widget.appFile.name}';
      final file = File(filePath);

      // This would actually download the file
      await widget.onFileDownloaded(file);

      setState(() {
        _cachedFile = file;
      });
    } catch (e) {
      // Handle download error
      log('Error downloading file: $e');
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  void _viewFile() {
    if (_cachedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            file: _cachedFile!,
            fileName: widget.appFile.name,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(widget.appFile.name),
        subtitle: Text('${widget.appFile.type.toUpperCase()} • ${widget.appFile.views} visitas'),
        trailing: ElevatedButton(
          onPressed: () {
            widget.onView();
            _cachedFile != null ? _viewFile() : _downloadFile();
          },
          child: _isDownloading ? const CircularProgressIndicator() : Text(_cachedFile != null ? 'Ver' : 'Descargar'),
        ),
      ),
    );
  }
}
