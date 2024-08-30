import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

part 'google_sign_in_controller.g.dart';

@riverpod
class GoogleSignInController extends _$GoogleSignInController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }
  Future<bool> submit() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authenticate());
    return state.hasError == false;
  }

  Future<void> _authenticate() {
    final authRepository = ref.read(authRepositoryProvider);
    return authRepository.signInWithGoogle();
  }
}
