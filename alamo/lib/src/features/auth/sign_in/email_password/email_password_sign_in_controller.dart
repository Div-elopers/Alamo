import 'dart:async';

import 'package:alamo/src/features/auth/application/user_service.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_password_sign_in_controller.g.dart';

@riverpod
class EmailPasswordSignInController extends _$EmailPasswordSignInController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  FutureOr<void> build() {
    // nothing to do
  }

  bool get isLoading => state.isLoading;

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = await AsyncValue.guard(() => _signIn(email, password));
    return !state.hasError;
  }

  // Método para registrarse
  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    state = await AsyncValue.guard(() => _signUp(email, password));
    return !state.hasError;
  }

  // Método específico para manejar el inicio de sesión
  Future<void> _signIn(String email, String password) async {
    final userService = ref.read(userServiceProvider);
    try {
      await userService.signInWithEmailAndPassword(email: email, password: password);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // Método específico para manejar el registro de usuario
  Future<void> _signUp(String email, String password) async {
    final userService = ref.read(userServiceProvider);
    try {
      await userService.signUpWithEmailAndPassword(email: email, password: password);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final userService = ref.read(userServiceProvider);
    state = await AsyncValue.guard(() async {
      await userService.sendPasswordResetEmail(email);
    });
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
