import 'dart:async';
import 'package:alamo/src/features/library/domain/app_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'files_repository.g.dart';

class FilesRepository {
  const FilesRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Firestore paths for files
  static String filesPath() => 'files';
  static String filePath(String id) => 'files/$id';

  // Fetch a list of all files
  Future<List<AppFile>> fetchFilesList() async {
    final ref = _filesRef();
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  // Watch the list of all files as a stream
  Stream<List<AppFile>> watchFilesList() {
    final ref = _filesRef();
    return ref.snapshots().map((snapshot) => snapshot.docs.map((docSnap) => docSnap.data()).toList());
  }

  // Fetch a single file by ID
  Future<AppFile?> fetchFile(String id) async {
    final ref = _fileRef(id);
    final snapshot = await ref.get();
    return snapshot.data();
  }

  // Create or update a file
  Future<void> createFile(AppFile file) async {
    final docRef = await _firestore.collection(filesPath()).add(file.toJson());

    // You now have the generated document ID (uid) in docRef.id
    final fileId = docRef.id;

    // You can now call the set method to set the file with its auto-generated ID
    await docRef.update({'id': fileId});
  }

  // Update a file
  Future<void> updateFile(AppFile file) {
    final ref = _fileRef(file.id);
    return ref.set(file, SetOptions(merge: true));
  }

  // Delete a file by ID
  Future<void> deleteFile(String id) {
    return _firestore.doc(filePath(id)).delete();
  }

  Stream<AppFile?> watchFile(String uid) {
    final ref = _fileRef(uid);
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  // Helper methods to create Firestore references
  DocumentReference<AppFile> _fileRef(String id) => _firestore.doc(filePath(id)).withConverter(
        fromFirestore: (doc, _) => AppFile.fromJson(doc.data()!),
        toFirestore: (file, _) => file.toJson(),
      );

  Query<AppFile> _filesRef() => _firestore.collection(filesPath()).withConverter(
        fromFirestore: (doc, _) => AppFile.fromJson(doc.data()!),
        toFirestore: (file, _) => file.toJson(),
      );
}

@Riverpod(keepAlive: true)
FilesRepository filesRepository(Ref ref) {
  return FilesRepository(FirebaseFirestore.instance);
}

// Providers for file operations

@riverpod
Stream<List<AppFile>> filesListStream(Ref ref) {
  final filesRepository = ref.watch(filesRepositoryProvider);
  return filesRepository.watchFilesList();
}

@riverpod
Future<List<AppFile>> filesListFuture(Ref ref) {
  final filesRepository = ref.watch(filesRepositoryProvider);
  return filesRepository.fetchFilesList();
}

@riverpod
Stream<AppFile?> fileStream(Ref ref, String id) {
  final filesRepository = ref.watch(filesRepositoryProvider);
  return filesRepository.watchFile(id);
}

@riverpod
Future<AppFile?> fileFuture(Ref ref, String id) {
  final filesRepository = ref.watch(filesRepositoryProvider);
  return filesRepository.fetchFile(id);
}
