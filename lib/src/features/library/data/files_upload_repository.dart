import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  Future<TaskSnapshot> uploadFileFromFile({
    required String folder,
    required File file,
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
  Future<TaskSnapshot> _uploadFile(String path, File file, String contentType) {
    final ref = _storage.ref(path);
    final uploadTask = ref.putFile(
      file,
      SettableMetadata(contentType: contentType),
    );

    return uploadTask.whenComplete(() => uploadTask.snapshot);
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
