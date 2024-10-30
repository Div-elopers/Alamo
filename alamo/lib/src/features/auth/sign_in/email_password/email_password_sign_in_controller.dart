import 'dart:async';
import 'package:alamo/src/features/auth/application/user_service.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_password_sign_in_controller.g.dart';

@riverpod
class EmailPasswordSignInController extends _$EmailPasswordSignInController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final departmentController = TextEditingController();
  final repitpassController = TextEditingController();

  @override
  FutureOr<void> build() {
    // Initial setup or state if necessary
  }

  bool get isLoading => state.isLoading;

  Future<void> sendPasswordResetEmail(String email) async {
    final userService = ref.read(userServiceProvider);
    state = await AsyncValue.guard(() async {
      await userService.sendPasswordResetEmail(email);
    });
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = await AsyncValue.guard(() => _signIn(email, password));
    return !state.hasError;
  }

  Future<bool> signUp({
    required String name,
    required String phoneNumber,
    required String department,
    required String email,
    required String password,
    required String repeatPassword,
  }) async {
    phoneNumber = formatPhoneNumber(phoneNumber);
    state = await AsyncValue.guard(() => _signUp(name, phoneNumber, department, email, password));
    return !state.hasError;
  }

  Future<void> _signIn(String email, String password) async {
    final userService = ref.read(userServiceProvider);
    await userService.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> _signUp(
    String name,
    String phoneNumber,
    String department,
    String email,
    String password,
  ) async {
    final userService = ref.read(userServiceProvider);
    await userService.signUpWithEmailAndPassword(
      email: email,
      password: password,
      additionalInfo: {
        'name': name,
        'phoneNumber': phoneNumber,
        'department': department,
      },
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // super.dispose();
  }

  String formatPhoneNumber(String phoneNumber) {
    try {
      final parsedNumber = PhoneNumber.parse(phoneNumber, callerCountry: IsoCode.UY);
      return "598${parsedNumber.formatNsn(isoCode: IsoCode.UY)}";
    } catch (e) {
      return phoneNumber;
    }
  }
}
