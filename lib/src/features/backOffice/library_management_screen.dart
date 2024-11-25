import 'dart:developer';

import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/features/library/presentation/library_screen_controller.dart';
import 'package:alamo/src/widgets/alert_dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;

import 'package:alamo/src/features/library/domain/app_file.dart';
import 'package:alamo/src/features/library/application/files_service.dart';

class LibraryManagementScreen extends ConsumerStatefulWidget {
  const LibraryManagementScreen({super.key});

  @override
  createState() => _LibraryManagementState();
}

class _LibraryManagementState extends ConsumerState<LibraryManagementScreen> {
  final fileNameController = TextEditingController();
  late PlatformFile selectedFile;
  @override
  void initState() {
    super.initState();
    selectedFile = PlatformFile(name: '', size: 1);
  }

  @override
  void dispose() {
    super.dispose();
    selectedFile = PlatformFile(name: '', size: 1);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(libraryScreenControllerProvider.notifier);
    final files = ref.watch(libraryScreenControllerProvider).filteredFiles;

    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administración de biblioteca'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width / 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            gapH32,
            const Text("Aquí puedes subir los archivos que se verán desde la aplicación."),
            gapH32,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: TextField(
                    controller: fileNameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () async {
                    await _pickFile();
                  },
                ),
              ],
            ),
            gapH32,
            ElevatedButton(
              onPressed: () async {
                if (fileNameController.text.isNotEmpty) {
                  final fileName = selectedFile.name;
                  final fileExtension = fileName.split('.').last;
                  await controller.uploadFile(
                    name: fileNameController.text.isNotEmpty ? fileNameController.text : fileName,
                    type: fileExtension,
                    file: selectedFile,
                    createdBy: 'Admin',
                  );
                } else {
                  // Show error message
                  showAlertDialog(context: context, title: 'Error', content: 'Por favor completa los campos y selecciona un archivo.');
                }
              },
              child: const Text('Subir archivo'),
            ),
            gapH64,
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Nombre',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Tipo',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Acción',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                  ],
                  rows: files.map((file) {
                    bool isEvenRow = files.indexOf(file) % 2 == 0;

                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return isEvenRow ? Colors.grey.shade100 : Colors.white;
                        },
                      ),
                      cells: [
                        DataCell(
                          GestureDetector(
                            onTap: () {
                              html.window.open(file.fileURL, '_blank');
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                child: Text(
                                  file.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            child: Text(
                              file.type,
                              style: const TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              controller.deleteFile(fileId: file.id, type: file.type, name: file.name);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;

      setState(() {
        selectedFile = file;

        fileNameController.text = fileNameController.text.isEmpty ? file.name : fileNameController.text;
      });
    }
  }
}
