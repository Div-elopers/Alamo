import 'dart:async';

import 'package:alamo/src/localization/string_hardcoded.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/app_user.dart';
import 'firebase_app_user.dart';
import 'dart:developer' as developer;

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e);
      developer.log('Authentication failed: $errorMessage');
      throw errorMessage; // Throw custom error message
    } catch (e) {
      // * Catching any other generic exceptions
      final errorMessage = _handleGenericError(e);
      developer.log('An unexpected error occurred: $errorMessage');
      throw errorMessage;
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (name != null || name != "") {
        // Set the display name for the user
        await userCredential.user?.updateProfile(displayName: name);

        // Reload the user to make sure the display name is updated
        await userCredential.user?.reload();
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e);
      developer.log('User creation failed: $errorMessage');
      throw errorMessage;
    } catch (e) {
      // Catching any other generic exceptions
      final errorMessage = _handleGenericError(e);
      developer.log('An unexpected error occurred: $errorMessage');
      throw errorMessage;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: _getErrorMessage(e),
      );
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on Exception catch (e) {
      developer.log(
        'Exception caught: $e',
        level: 200,
        name: 'Google Sign In',
      );
    }
  }

  Future<void> deleteUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        // Firebase Auth API call to delete the user
        await currentUser.delete();
      } on FirebaseAuthException catch (e) {
        final errorMessage = _getErrorMessage(e);
        developer.log('Error $e');
        developer.log('Fallo borrar el usuario: $errorMessage');
        throw errorMessage;
      } catch (e) {
        final errorMessage = _handleGenericError(e);
        developer.log('An unexpected error occurred: $errorMessage');
        throw errorMessage;
      }
    } else {
      throw 'No existe la sesión del usuario.'.hardcoded;
    }
  }

  Future<void> reloadCurrentUser() async {
    return await _auth.currentUser!.reload();
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(_convertUser);
  }

  AppUser? get currentUser {
    return _convertUser(_auth.currentUser);
  }

  FirebaseAppUser? _convertUser(User? user) => user != null ? FirebaseAppUser(user) : null;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneVerificationResult) onVerificationCompleted,
    required void Function(PhoneVerificationResult) onCodeSent,
    required void Function(PhoneVerificationResult) onAutoRetrievalTimeout,
    required void Function(PhoneVerificationResult) onVerificationFailed,
    Duration timeout = const Duration(seconds: 30),
    int? forceResendingToken,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeout,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Call the callback with a PhoneVerificationResult for completed verification
          onVerificationCompleted(PhoneVerificationResult(
            status: PhoneVerificationStatus.verificationCompleted,
          ));
        },
        verificationFailed: (FirebaseAuthException e) {
          // Call the callback for failed verification
          onVerificationFailed(PhoneVerificationResult(
            status: PhoneVerificationStatus.verificationFailed,
            errorMessage: e.message,
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          // Call the callback for code sent
          onCodeSent(PhoneVerificationResult(
            status: PhoneVerificationStatus.codeSent,
            verificationId: verificationId,
            resendToken: resendToken,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Call the callback for auto retrieval timeout
          onAutoRetrievalTimeout(PhoneVerificationResult(
            status: PhoneVerificationStatus.autoRetrievalTimeout,
            verificationId: verificationId,
          ));
        },
        forceResendingToken: forceResendingToken,
      );
    } on FirebaseAuthException catch (e) {
      onVerificationFailed(PhoneVerificationResult(
        status: PhoneVerificationStatus.verificationFailed,
        errorMessage: e.message,
      ));
    } on Exception catch (e) {
      developer.log(
        'Exception caught: $e',
        level: 200,
        name: 'Google Sign In',
      );
      rethrow;
    }
  }

  Future<bool> verifyPhoneCode(String verificationId, String smsCode) async {
    try {
      // Create a PhoneAuthCredential with the verification ID and SMS code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      User currentUser = _auth.currentUser!;

      await currentUser.linkWithCredential(credential);

      currentUser = _auth.currentUser!;

      // If the current user is already linked with a phone number, no need to link again
      if (currentUser.phoneNumber != null && currentUser.phoneNumber!.isNotEmpty) {
        return true; // Phone number is already linked, verification successful
      }

      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        // If the provider is already linked, it's not an error, just return success
        return true;
      } else {
        // Otherwise, rethrow the exception to be handled elsewhere
        throw FirebaseAuthException(
          code: e.code,
          message: e.message,
        );
      }
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Este correo electrónico ya está en uso.'.hardcoded;
      case 'invalid-email':
        return 'El correo electrónico no es válido.'.hardcoded;
      case 'operation-not-allowed':
        return 'Esta operación no está permitida.'.hardcoded;
      case 'weak-password':
        return 'La contraseña es demasiado débil.'.hardcoded;
      case 'too-many-requests':
        return 'Demasiadas solicitudes. Intenta de nuevo más tarde.'.hardcoded;
      case 'user-token-expired':
        return 'El token de usuario ha expirado. Por favor, inicia sesión de nuevo.'.hardcoded;
      case 'network-request-failed':
        return 'Error de red. Verifica tu conexión a internet.'.hardcoded;
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Credenciales de inicio de sesión no válidas.'.hardcoded;
      default:
        return 'Ha ocurrido un error. Por favor, intenta de nuevo.'.hardcoded;
    }
  }

  String _handleGenericError(Object e) => 'Ha ocurrido un error inesperado. Inténtalo de nuevo.'.hardcoded;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(FirebaseAuth.instance);
}

// * Using keepAlive since other providers need it to be an
// * [AlwaysAliveProviderListenable]
@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
