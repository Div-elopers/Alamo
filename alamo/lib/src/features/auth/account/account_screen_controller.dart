import 'dart:async';

import 'package:alamo/src/features/auth/application/user_service.dart';
//import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/domain/app_user.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_screen_controller.g.dart';

@riverpod
class AccountScreenController extends _$AccountScreenController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }
  Future<void> signOut() async {
    final userService = ref.read(userServiceProvider);
    state = await AsyncValue.guard(() => userService.signOut());
  }

  Future<bool> sendEmailVerification() async {
    final userService = ref.read(userServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => userService.sendEmailVerification());
    return state.hasError == false;
  }

  Future<void> deleteAccount() async {
    final userService = ref.read(userServiceProvider);

    state = await AsyncValue.guard(() => userService.deleteUserAccount());
    ref.read(goRouterProvider).goNamed(AppRoute.signIn.name);
  }

  Future<bool> reloadUserAndSyncWithFirestore() async {
    final userService = ref.read(userServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => userService.reloadUserAndSyncWithFirestore());
    return state.hasError == false;
  }

  Future<void> verifyPhone({
    required String phoneNumber,
    required void Function(PhoneVerificationResult) onVerificationCompleted,
    required void Function(PhoneVerificationResult) onCodeSent,
    required void Function(PhoneVerificationResult) onAutoRetrievalTimeout,
    required void Function(PhoneVerificationResult) onVerificationFailed,
  }) async {
    final userService = ref.read(userServiceProvider);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return userService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onVerificationCompleted: onVerificationCompleted,
        onCodeSent: onCodeSent,
        onAutoRetrievalTimeout: onAutoRetrievalTimeout,
        onVerificationFailed: onVerificationFailed,
      );
    });
  }

  Future<bool> verifyPhoneCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final userService = ref.read(userServiceProvider);

    state = const AsyncLoading();

    final result = await AsyncValue.guard(() async {
      await userService.verifyPhoneCode(verificationId, smsCode);
    });

    if (result.hasValue == true) {
      state = result;
      return true;
    } else {
      // If there's an error, set the state to AsyncError
      state = AsyncError(result.error!, StackTrace.current);
      return false;
    }
  }
}
