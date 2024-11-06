import 'dart:io';

import 'package:alamo/src/features/library/data/files_repository.dart';
import 'package:alamo/src/features/library/data/files_upload_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/app_file.dart';

part 'files_service.g.dart';

class FilesService {
  FilesService(this._filesRepository, this._filesUploadRepository);

  final FilesRepository _filesRepository;
  final FilesUploadRepository _filesUploadRepository;

  /// Uploads a file to Firebase Storage and saves its metadata to Firestore.
  Future<void> uploadFile({
    required String name,
    required String type,
    required File file,
    required String createdBy,
  }) async {
    final contentType = _getContentType(type);
    final folder = _getFolder(type);
    final filename = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

    // Upload file to Firebase Storage
    final uploadTaskSnapshot = await _filesUploadRepository.uploadFileFromFile(
      folder: folder,
      file: file,
      filename: filename,
      contentType: contentType,
    );

    // Get download URL
    final downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();

    // Create AppFile and save metadata to Firestore
    final appFile = AppFile(
      id: uploadTaskSnapshot.ref.name,
      name: name,
      type: type,
      createdAt: DateTime.now(),
      fileURL: downloadUrl,
      createdBy: createdBy,
    );

    await _filesRepository.createFile(appFile);
  }

  /// Fetches a list of files from Firestore.
  Future<List<AppFile>> fetchFiles() async {
    return await _filesRepository.fetchFilesList();
  }

  /// Watches a list of files as a stream.
  Stream<List<AppFile>> watchFiles() {
    return _filesRepository.watchFilesList();
  }

  /// Deletes a file from Firebase Storage and its metadata from Firestore.
  Future<void> deleteFile(String fileId, String type) async {
    final folder = _getFolder(type);

    // Delete file from Firebase Storage
    await _filesUploadRepository.deleteFile('$folder/$fileId');

    // Delete file metadata from Firestore
    await _filesRepository.deleteFile(fileId);
  }

  // Updates the views count of a file.
  Future<void> incrementFileViews(AppFile appFile) async {
    final updatedFile = appFile.copyWith(views: appFile.views + 1);
    await _filesRepository.updateFile(updatedFile);
  }

  /// Helper method to determine content type based on file type.
  String _getContentType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'video':
        return 'video/mp4'; // Adjust as needed
      case 'doc':
        return 'application/msword'; // Adjust as needed
      default:
        return 'application/octet-stream';
    }
  }

  /// Helper method to determine folder based on file type.
  String _getFolder(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return 'pdfs';
      case 'video':
        return 'videos';
      case 'doc':
        return 'docs';
      default:
        return 'others';
    }
  }
}

@Riverpod(keepAlive: true)
FilesService filesService(Ref ref) {
  final filesRepository = ref.watch(filesRepositoryProvider);
  final filesUploadRepository = ref.watch(filesUploadRepositoryProvider);
  return FilesService(filesRepository, filesUploadRepository);
}
