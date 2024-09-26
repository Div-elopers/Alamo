import 'package:alamo/src/features/auth/application/user_service.dart';
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
    state = await AsyncValue.guard(() => _authenticate());
    return state.hasError == false;
  }

  Future<void> _authenticate() {
    final userService = ref.read(userServiceProvider);
    return userService.signInWithGoogle();
  }
}
