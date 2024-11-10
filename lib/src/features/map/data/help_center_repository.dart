import 'dart:async';

import 'package:alamo/src/features/map/domain/help_center.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'help_center_repository.g.dart';

class HelpCenterRepository {
  const HelpCenterRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Firestore paths for help centers
  static String helpCentersPath() => 'help_centers';
  static String helpCenterPath(String uid) => 'help_centers/$uid';

  // Fetch the list of all help centers
  Future<List<HelpCenter>> fetchHelpCentersList() async {
    final ref = _helpCentersRef();
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  // Watch the list of all help centers as a stream
  Stream<List<HelpCenter>> watchHelpCentersList() {
    final ref = _helpCentersRef();
    return ref.snapshots().map((snapshot) => snapshot.docs.map((docSnap) => docSnap.data()).toList());
  }

  // Fetch a single help center by uid
  Future<HelpCenter?> fetchHelpCenter(String uid) async {
    final ref = _helpCenterRef(uid);
    final snapshot = await ref.get();
    return snapshot.data();
  }

  // Watch a single help center by uid as a stream
  Stream<HelpCenter?> watchHelpCenter(String uid) {
    final ref = _helpCenterRef(uid);
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  // Create or update a help center
  Future<void> createHelpCenter(HelpCenter helpCenter) async {
    final helpCentersCollection = _firestore.collection(helpCentersPath());

    await helpCentersCollection.add(helpCenter.toJson());
  }

  // Update a help center
  Future<void> updateHelpCenter(HelpCenter helpCenter) {
    final ref = _helpCenterRef(helpCenter.uid);
    return ref.set(helpCenter, SetOptions(merge: true));
  }

  // Delete a help center by uid
  Future<void> deleteHelpCenter(String uid) {
    return _firestore.doc(helpCenterPath(uid)).delete();
  }

  // Helper methods to create Firestore references
  DocumentReference<HelpCenter> _helpCenterRef(String uid) => _firestore.doc(helpCenterPath(uid)).withConverter(
        fromFirestore: (doc, _) => HelpCenter.fromJson(doc.data()!),
        toFirestore: (helpCenter, _) => helpCenter.toJson(),
      );

  Query<HelpCenter> _helpCentersRef() => _firestore.collection(helpCentersPath()).withConverter(
        fromFirestore: (doc, _) => HelpCenter.fromJson(doc.data()!),
        toFirestore: (helpCenter, _) => helpCenter.toJson(),
      );
}

@Riverpod(keepAlive: true)
HelpCenterRepository helpCenterRepository(Ref ref) {
  return HelpCenterRepository(FirebaseFirestore.instance);
}

// A provider for fetching the list of help centers as a stream
@riverpod
Stream<List<HelpCenter>> helpCentersListStream(Ref ref) {
  final helpCenterRepository = ref.watch(helpCenterRepositoryProvider);
  return helpCenterRepository.watchHelpCentersList();
}

// A provider for fetching the list of help centers as a future
@riverpod
Future<List<HelpCenter>> helpCentersListFuture(Ref ref) {
  final helpCenterRepository = ref.watch(helpCenterRepositoryProvider);
  return helpCenterRepository.fetchHelpCentersList();
}

// A provider for watching a specific help center by their uid
@riverpod
Stream<HelpCenter?> helpCenterStream(Ref ref, String uid) {
  final helpCenterRepository = ref.watch(helpCenterRepositoryProvider);
  return helpCenterRepository.watchHelpCenter(uid);
}

// A provider for fetching a specific help center by their uid
@riverpod
Future<HelpCenter?> helpCenterFuture(Ref ref, String uid) {
  final helpCenterRepository = ref.watch(helpCenterRepositoryProvider);
  return helpCenterRepository.fetchHelpCenter(uid);
}
