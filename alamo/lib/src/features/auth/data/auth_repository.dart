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

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) {
    try {
      return _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e);
      developer.log('User creation failed: $errorMessage');
      throw errorMessage;
    } catch (e) {
      // * Catching any other generic exceptions
      final errorMessage = _handleGenericError(e);
      developer.log('An unexpected error occurred: $errorMessage');
      throw errorMessage;
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
