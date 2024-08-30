import 'dart:async';

import 'package:alamo/src/features/auth/sign_in/email_password/email_password_sign_in_form_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository.dart';

part 'email_password_sign_in_controller.g.dart';

@riverpod
class EmailPasswordSignInController extends _$EmailPasswordSignInController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }
  Future<bool> submit({required String email, required String password, required EmailPasswordSignInFormType formType}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authenticate(email, password, formType));
    return state.hasError == false;
  }

  Future<void> _authenticate(String email, String password, EmailPasswordSignInFormType formType) {
    final authRepository = ref.read(authRepositoryProvider);
    switch (formType) {
      case EmailPasswordSignInFormType.signIn:
        return authRepository.signInWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.register:
        return authRepository.createUserWithEmailAndPassword(email, password);
    }
  }
}
