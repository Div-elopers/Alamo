import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:universal_html/html.dart' as html;

part 'files_upload_repository.g.dart';

class FilesUploadRepository {
  final _storage = FirebaseStorage.instanceFor(bucket: "gs://alamo-utec.firebasestorage.app");

  /// Uploads a file from [ByteData] to Firebase Storage in the specified [folder] (e.g., "videos", "pdfs", "docs").
  Future<TaskSnapshot> uploadFileFromBytes({
    required String folder,
    required ByteData byteData,
    required String filename,
    required String contentType,
  }) async {
    final path = '$folder/$filename';
    return await _uploadAsset(path, byteData, contentType);
  }

  /// Uploads a file from a local [File] object to Firebase Storage in the specified [folder].
  Future<String> uploadFileFromFile({
    required String folder,
    required dynamic file,
    required String filename,
    required String contentType,
  }) async {
    final path = '$folder/$filename';
    return await _uploadFile(path, file, contentType);
  }

  /// Helper method to upload [ByteData] to Firebase Storage.
  Future<TaskSnapshot> _uploadAsset(String path, ByteData byteData, String contentType) {
    final bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    final ref = _storage.ref(path);
    final uploadTask = ref.putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );

    return uploadTask.whenComplete(() => uploadTask.snapshot);
  }

  /// Helper method to upload a [File] to Firebase Storage.

  Future<String> _uploadFile(String path, dynamic file, String contentType) async {
    try {
      if (kIsWeb) {
        final blob = html.Blob([file.bytes!], contentType);

        TaskSnapshot uploadTask = await FirebaseStorage.instance.ref(path).putBlob(blob, SettableMetadata(contentType: contentType));

        // Upload the byte data to Firebase Storage

        return await uploadTask.ref.getDownloadURL();
      } else {
        // For non-web platforms (Android, iOS, etc.), use Firebase's regular storage

        if (file is File) {
          final uploadTask = await FirebaseStorage.instance.ref(path).putFile(file);

          return await uploadTask.ref.getDownloadURL();
        } else {
          throw Exception("File is not of type File (dart:io.File)");
        }
      }
    } catch (e) {
      log('File upload failed: $e');
      rethrow;
    }
  }

  Future<void> deleteFile(String path) async {
    final ref = _storage.ref(path);
    return await ref.delete();
  }

  /// Method to get a download URL for a file stored in Firebase Storage.
  Future<String> getDownloadUrl(String path) async {
    final ref = _storage.ref(path);
    return await ref.getDownloadURL();
  }
}

@Riverpod(keepAlive: true)
FilesUploadRepository filesUploadRepository(Ref ref) {
  return FilesUploadRepository();
}
