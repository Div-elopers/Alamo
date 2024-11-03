import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_photo_repository.g.dart'; // Replace with your file name

class ProfileImageRepository {
  ProfileImageRepository();
  final _storage = FirebaseStorage.instanceFor(bucket: "gs://alamo-utec.firebasestorage.app");

  Future<String> uploadProfileImageFromFile(File file, String userID) async {
    const contentType = 'image/jpeg';
    final byteData = await getFileByteData(file);
    final filename = 'profile_$userID.jpg';

    final snapshot = await _uploadAsset('profile', byteData, filename, contentType);

    if (snapshot.state == TaskState.success) {
      return await snapshot.ref.getDownloadURL();
    } else {
      throw FirebaseException(plugin: 'firebase_storage', code: 'upload-failed', message: 'Profile image upload failed');
    }
  }

  Future<TaskSnapshot> _uploadAsset(String path, ByteData byteData, String filename, String contentType) {
    final bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    final ref = _storage.ref('$path/$filename');
    final uploadTask = ref.putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );

    return uploadTask.whenComplete(() => uploadTask.snapshot);
  }

  Future<void> deleteProductImage(String imageUrl) {
    return _storage.refFromURL(imageUrl).delete();
  }
}

@Riverpod(keepAlive: true)
ProfileImageRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileImageRepository();
}

Future<ByteData> getFileByteData(File file) async {
  final bytes = await file.readAsBytes();
  final byteData = ByteData.view(bytes.buffer);
  return byteData;
}
