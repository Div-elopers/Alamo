import 'dart:async';

import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/data/users_repository.dart';
import 'package:alamo/src/features/chat/data/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/app_user.dart';

part 'user_service.g.dart';

class UserService {
  const UserService(this._authRepository, this._userRepository, this._chatRepository);
  final AuthRepository _authRepository;
  final UsersRepository _userRepository;
  final ChatRepository _chatRepository;

  // Register a new user
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required Map<String, String> additionalInfo,
  }) async {
    final userCredential = await _authRepository.createUserWithEmailAndPassword(email, password);
    final user = userCredential.user;

    if (user != null) {
      // Create user profile in Firestore with additional information
      final appUser = AppUser(
        uid: user.uid,
        email: user.email,
        emailVerified: user.emailVerified,
        phoneVerified: false,
        name: additionalInfo['name'] ?? '',
        phoneNumber: additionalInfo['phoneNumber'],
        department: additionalInfo['department'],
        createdAt: DateTime.now(),
      );
      await _userRepository.createUser(appUser);
    }
  }

  // Sign in with email and password
  Future<AppUser?> signInWithEmailAndPassword({required String email, required String password}) async {
    final userCredential = await _authRepository.signInWithEmailAndPassword(email, password);
    final user = userCredential?.user;
    await reloadUserAndSyncWithFirestore();
    if (user != null) {
      // Fetch user profile from Firestore
      return await _userRepository.fetchUser(user.uid);
    }
    return null;
  }

  // Sign in with Google
  Future<AppUser?> signInWithGoogle() async {
    final userCredential = await _authRepository.signInWithGoogle();
    final user = userCredential?.user;

    if (user != null) {
      final existingUser = await _userRepository.fetchUser(user.uid);

      if (existingUser == null) {
        // If the user does not exist, create a new profile in Firestore
        final appUser = AppUser(
          uid: user.uid,
          email: user.email,
          emailVerified: user.emailVerified,
          phoneVerified: false,
          name: "",
        );
        await _userRepository.createUser(appUser);
      }

      // Return the existing or newly created user
      return existingUser ??
          AppUser(
            uid: user.uid,
            email: user.email,
            emailVerified: user.emailVerified,
            phoneVerified: false,
            name: "",
          );
    }

    return null;
  }

  // Update user profile
  Future<void> updateUser(AppUser updatedUser) async {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null && currentUser.uid == updatedUser.uid) {
      // Sync updates to Firestore
      await _userRepository.updateUser(updatedUser);
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  // Delete user account
  Future<void> deleteUserAccount() async {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;

      // Delete user from Firestore
      await _userRepository.deleteUser(userId);

      final chatId = await _chatRepository.findChatByParticipant(userId);

      if (chatId != null) {
        await _chatRepository.deleteChat(chatId);
      }

      // Sign out from authentication
      await _authRepository.deleteUser();
    }
  }

  // Get the current authenticated user
  AppUser? get currentUser {
    final firebaseUser = _authRepository.currentUser;
    if (firebaseUser != null) {
      return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        emailVerified: firebaseUser.emailVerified,
        phoneVerified: false,
      );
    }
    return null;
  }

  Future<void> reloadUserAndSyncWithFirestore() async {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      // Reload the user to get the updated email verification status
      await _authRepository.reloadCurrentUser();
      final updatedUser = _authRepository.currentUser;

      if (updatedUser != null && (updatedUser.emailVerified || updatedUser.phoneVerified)) {
        // Fetch the Firestore user profile
        final firestoreUser = await _userRepository.fetchUser(updatedUser.uid);

        // If the Firestore user exists and the emailVerified or phoneVerified status is not updated, update Firestore
        if (firestoreUser != null && (!firestoreUser.emailVerified || !firestoreUser.phoneVerified)) {
          firestoreUser.emailVerified = updatedUser.emailVerified;
          firestoreUser.phoneVerified = updatedUser.phoneVerified;
          await _userRepository.updateUser(firestoreUser);
        }
      }
    }
  }

  Future<void> sendEmailVerification() async {
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      return currentUser.sendEmailVerification();
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneVerificationResult p1) onVerificationCompleted,
    required void Function(PhoneVerificationResult p1) onCodeSent,
    required void Function(PhoneVerificationResult p1) onAutoRetrievalTimeout,
    required void Function(PhoneVerificationResult p1) onVerificationFailed,
  }) async {
    return await _authRepository.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onVerificationCompleted: onVerificationCompleted,
        onCodeSent: onCodeSent,
        onAutoRetrievalTimeout: onAutoRetrievalTimeout,
        onVerificationFailed: onVerificationFailed);
  }

  Future<bool> verifyPhoneCode(String verificationId, String smsCode) async {
    final success = await _authRepository.verifyPhoneCode(verificationId, smsCode);
    if (success) {
      await reloadUserAndSyncWithFirestore();
    }
    return success;
  }

  sendPasswordResetEmail(String email) async {
    await _authRepository.sendPasswordResetEmail(email);
  }
}

@Riverpod(keepAlive: true)
UserService userService(UserServiceRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final chatRepository = ref.watch(chatRepositoryProvider);
  return UserService(authRepository, userRepository, chatRepository);
}
