import 'dart:async';

import 'package:alamo/src/features/auth/application/user_service.dart';
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
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => userService.signOut());
  }

  Future<bool> sendEmailVerification() async {
    final userService = ref.read(userServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => userService.sendEmailVerification());
    return state.hasError == false;
  }

  Future<bool> deleteAccount() async {
    final userService = ref.read(userServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => userService.deleteUserAccount());
    return state.hasError == false;
  }

  Future<bool> reloadUserAndSyncWithFirestore() async {
    final userService = ref.read(userServiceProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => userService.reloadUserAndSyncWithFirestore());
    return state.hasError == false;
  }
}
