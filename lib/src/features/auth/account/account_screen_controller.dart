import 'dart:async';
import 'dart:io';

import 'package:alamo/src/features/auth/application/user_service.dart';
//import 'package:alamo/src/features/auth/data/auth_repository.dart';
import 'package:alamo/src/features/auth/domain/app_user.dart';
import 'package:alamo/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_screen_controller.g.dart';

@riverpod
class AccountScreenController extends _$AccountScreenController {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final departmentController = TextEditingController();

  @override
  FutureOr<void> build() {}

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

  Future<void> deleteAccount(String? uid) async {
    final userId = (uid != null && uid.isNotEmpty) ? uid : "";
    final userService = ref.read(userServiceProvider);

    state = await AsyncValue.guard(() => userService.deleteUserAccount(userId));
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

  Future<void> updateProfilePhoto(File imageFile) async {
    final userService = ref.read(userServiceProvider);

    await AsyncValue.guard(() async {
      await userService.uploadProfilePhoto(imageFile);
    });
  }

  Future<void> updateProfile({
    required String name,
    required String phoneNumber,
    required String department,
    required String email,
    required String uid,
  }) async {
    // Create an AppUser instance with the updated data
    final updatedUser = AppUser(
      uid: uid,
      name: name,
      phoneNumber: phoneNumber,
      department: department,
      email: email,
    );

    final userService = ref.read(userServiceProvider);

    await AsyncValue.guard(() async {
      await userService.updateUser(updatedUser);
    });
  }
}
