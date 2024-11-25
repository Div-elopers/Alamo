import 'dart:async';

import 'package:alamo/src/features/auth/domain/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_repository.g.dart';

class UsersRepository {
  const UsersRepository(this._firestore);
  final FirebaseFirestore _firestore;

  // Firestore paths for users
  static String usersPath() => 'users';
  static String userPath(String uid) => 'users/$uid';

  // Fetch the list of all users
  Future<List<AppUser>> fetchUsersList() async {
    final ref = _usersRef();
    final snapshot = await ref.get();
    return snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  // Watch the list of all users as a stream
  Stream<List<AppUser>> watchUsersList() {
    final ref = _usersRef();
    return ref.snapshots().map((snapshot) => snapshot.docs.map((docSnap) => docSnap.data()).toList());
  }

  // Fetch a single user by uid
  Future<AppUser?> fetchUser(String uid) async {
    final ref = _userRef(uid);
    final snapshot = await ref.get();
    return snapshot.data();
  }

  // Watch a single user by uid as a stream
  Stream<AppUser?> watchUser(String uid) {
    final ref = _userRef(uid);
    return ref.snapshots().map((snapshot) => snapshot.data());
  }

  // Create or update a user
  Future<void> createUser(AppUser user) {
    final ref = _userRef(user.uid.toString());
    return ref.set(user);
  }

  // Update a user
  Future<void> updateUser(AppUser user) {
    final ref = _userRef(user.uid);
    return ref.set(user, SetOptions(merge: true));
  }

  // Delete a user by uid
  Future<void> deleteUser(String uid) {
    return _firestore.doc(userPath(uid)).delete();
  }

  // Helper methods to create Firestore references
  DocumentReference<AppUser> _userRef(String uid) => _firestore.doc(userPath(uid)).withConverter(
        fromFirestore: (doc, _) => AppUser.fromJson(doc.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  Query<AppUser> _usersRef() => _firestore.collection(usersPath()).withConverter(
        fromFirestore: (doc, _) => AppUser.fromJson(doc.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  Future<void> updateUserProfileUrl(String userID, String downloadUrl) async {
    final ref = _userRef(userID);
    await ref.update({
      'profileUrl': downloadUrl,
    });
  }
}

@Riverpod(keepAlive: true)
UsersRepository userRepository(UserRepositoryRef ref) {
  return UsersRepository(FirebaseFirestore.instance);
}

// A provider for fetching the list of users as a stream
@riverpod
Stream<List<AppUser>> usersListStream(Ref ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.watchUsersList();
}

// A provider for fetching the list of users as a future
@riverpod
Future<List<AppUser>> usersListFuture(UsersListFutureRef ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchUsersList();
}

// A provider for watching a specific user by their uid
@riverpod
Stream<AppUser?> userStream(UserStreamRef ref, String uid) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.watchUser(uid);
}

// A provider for fetching a specific user by their uid
@riverpod
Future<AppUser?> userFuture(UserFutureRef ref, String uid) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchUser(uid);
}
